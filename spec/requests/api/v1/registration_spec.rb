# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Registration', type: :request do
  let(:client) { create(:user) }
  let(:client_2) { create(:user) }
  let(:activity_1) { create(:activity) }
  let(:activity_2) { create(:activity) }

  describe 'GET /index' do
    before do
      create(:registration, user_id: client.id, activity_id: activity_1.id)
      create(:registration, user_id: client.id, activity_id: activity_2.id)
      get '/api/v1/registrations/index'
    end

    it 'should return ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'should return 2 registrations' do
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'POST /create' do
    context 'when params are valid' do
      let(:valid_params) do
        {
          user_id: client.id,
          activity_id: activity_1.id
        }
      end

      before { post '/api/v1/registrations/create', params: { registration: valid_params } }

      it 'should return created status' do
        expect(response).to have_http_status(:created)
      end

      it 'should create a new registration' do
        new_registration = Registration.find_by(user_id: client.id)
        expect(new_registration).to_not be_nil
      end
    end

    context 'when params are not valid' do
      before { post '/api/v1/registrations/create', params: { registration: { user_id: client.id, activity_id: nil } } }

      it 'should return bad_request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'should not create a new registration' do
        new_registration = Registration.find_by(user_id: client.id)
        expect(new_registration).to be_nil
      end
    end
  end

  describe 'DELETE /delete' do
    let(:registration) { create(:registration, user_id: client.id) }

    context 'when registration exists' do
      before { delete "/api/v1/registrations/delete/#{registration.id}" }

      it 'should return ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'should delete the registration' do
        deleted_registration = Registration.find_by(user_id: client.id)
        expect(deleted_registration).to be_nil
      end
    end

    context 'when registration does not exists' do
      before do
        registration.destroy!
        delete "/api/v1/registrations/delete/#{registration.id}"
      end

      it 'should return bad_request status' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET /user_registrations' do
    before do
      create(:registration, user_id: client.id, activity_id: activity_1.id)
      create(:registration, user_id: client.id, activity_id: activity_2.id)
      create(:registration, user_id: client_2.id, activity_id: activity_1.id)
    end

    context 'user exists' do
      before { get "/api/v1/registrations/user_registrations/#{client.id}" }

      it 'should return ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'should return 2 registrations' do
        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    context 'user does not exists' do
      before do
        get '/api/v1/registrations/user_registrations/0'
      end

      it 'should return 0 registrations' do
        expect(JSON.parse(response.body).size).to eq(0)
      end
    end
  end
end
