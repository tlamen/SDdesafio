# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Activities', type: :request do
  let(:client) { create(:user, role: 3) }
  let(:teacher) { create(:user, role: 2) }
  let(:admin) { create(:user, role: 1) }

  describe 'GET /index' do
    before do
      create(:activity, name: 'activity 1')
      create(:activity, name: 'activity 2')
      get '/api/v1/activities/index'
    end

    it 'should return ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'should return 2 activities' do
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'GET /show' do
    let(:activity) { create(:activity) }

    context 'when activity exists' do
      before { get "/api/v1/activities/show/#{activity.id}" }

      it 'should have ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when activity does not exists' do
      before do
        activity.destroy!
        get "/api/v1/activities/show/#{activity.id}"
      end

      it 'should have not_found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /create' do
    let(:category) { create(:category) }
    let(:valid_params) do
      {
        name: 'new activity',
        description: 'activity created for tests',
        duration: 10,
        category_id: category.id,
        user_id: teacher.id,
        week_day: 'Tuesday',
        start_time: '15:00:00'
      }
    end

    context 'when client uses valid params' do
      before do
        post '/api/v1/activities/create', params: { activity: valid_params },
                                          headers: {
                                            'X-User-Email': client.email,
                                            'X-User-Token': client.authentication_token
                                          }
      end

      it 'should return unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'should not have saved the activity' do
        new_activity = Activity.find_by(name: 'new activity')
        expect(new_activity).to be_nil
      end
    end

    context 'when teacher uses valid params' do
      before do
        post '/api/v1/activities/create', params: { activity: valid_params },
                                          headers: {
                                            'X-User-Email': teacher.email,
                                            'X-User-Token': teacher.authentication_token
                                          }
      end

      it 'should return created status' do
        expect(response).to have_http_status(:created)
      end

      it 'should have saved the activity' do
        new_activity = Activity.find_by(name: 'new activity')
        expect(new_activity).to_not be_nil
      end
    end

    context 'when admin uses valid params' do
      before do
        post '/api/v1/activities/create', params: { activity: valid_params },
                                          headers: {
                                            'X-User-Email': admin.email,
                                            'X-User-Token': admin.authentication_token
                                          }
      end

      it 'should return created status' do
        expect(response).to have_http_status(:created)
      end

      it 'should have saved the activity' do
        new_activity = Activity.find_by(name: 'new activity')
        expect(new_activity).to_not be_nil
      end
    end

    context 'when params are not valid' do
      before do
        post '/api/v1/activities/create', params: { activity: { name: 'no description', description: nil } },
                                          headers: {
                                            'X-User-Email': admin.email,
                                            'X-User-Token': admin.authentication_token
                                          }
      end

      it 'should return unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should not have saved the activity' do
        new_activity = Activity.find_by(name: 'no description')
        expect(new_activity).to be_nil
      end
    end

    context 'when user is not logged' do
      before do
        post '/api/v1/activities/create', params: { activity: valid_params }
      end

      it 'should return found status' do
        expect(response).to have_http_status(:found)
      end

      it 'should not have saved the activity' do
        new_activity = Activity.find_by(name: 'new activity')
        expect(new_activity).to be_nil
      end
    end
  end

  describe 'PUT /update' do
    let(:activity) { create(:activity) }

    context 'when client uses valid params' do
      before do
        put "/api/v1/activities/update/#{activity.id}", params: {
          activity: { name: 'new name' }
        }, headers: {
          'X-User-Email': client.email,
          'X-User-Token': client.authentication_token
        }
        activity.reload
      end

      it 'should return unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'should not update activity' do
        expect(activity.name).to_not eq('new name')
      end
    end

    context 'when teacher uses valid params' do
      before do
        put "/api/v1/activities/update/#{activity.id}", params: {
          activity: { name: 'new name' }
        }, headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
        activity.reload
      end

      it 'should return ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'should update activity' do
        expect(activity.name).to eq('new name')
      end
    end

    context 'when admin uses valid params' do
      before do
        put "/api/v1/activities/update/#{activity.id}", params: {
          activity: { name: 'new name' }
        }, headers: {
          'X-User-Email': admin.email,
          'X-User-Token': admin.authentication_token
        }
        activity.reload
      end

      it 'should return ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'should update activity' do
        expect(activity.name).to eq('new name')
      end
    end

    context 'when activity does not exists' do
      before do
        activity.destroy!
        put "/api/v1/activities/update/#{activity.id}", params: {
          activity: { name: 'new name' }
        }, headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
      end

      it 'should return unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when params are not valid' do
      before do
        put "/api/v1/activities/update/#{activity.id}", params: {
          activity: { name: '' }
        }, headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
        activity.reload
      end

      it 'should return unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should not update activity' do
        expect(activity.name).to_not eq('')
      end
    end

    context 'when user is not logged' do
      before do
        put "/api/v1/activities/update/#{activity.id}", params: {
          activity: { name: 'new name' }
        }
        activity.reload
      end

      it 'should return found status' do
        expect(response).to have_http_status(:found)
      end

      it 'should not update activity' do
        expect(activity.name).to_not eq('new name')
      end
    end
  end

  describe 'DELETE /delete' do
    let(:activity) { create(:activity) }

    context 'when client tries to delete' do
      before do
        delete "/api/v1/activities/delete/#{activity.id}", headers: {
          'X-User-Email': client.email,
          'X-User-Token': client.authentication_token
        }
      end

      it 'should return unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'should not delete activity' do
        expect(Activity.find_by(id: activity.id)).to_not be_nil
      end
    end

    context 'when teacher tries to delete' do
      before do
        delete "/api/v1/activities/delete/#{activity.id}", headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
      end

      it 'should return ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'should delete activity' do
        expect(Activity.find_by(id: activity.id)).to be_nil
      end
    end

    context 'when admin tries to delete' do
      before do
        delete "/api/v1/activities/delete/#{activity.id}", headers: {
          'X-User-Email': admin.email,
          'X-User-Token': admin.authentication_token
        }
      end

      it 'should return ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'should delete activity' do
        expect(Activity.find_by(id: activity.id)).to be_nil
      end
    end
    context 'when activity does not exists' do
      before do
        activity.destroy!
        delete "/api/v1/activities/delete/#{activity.id}", headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
      end

      it 'should return bad_request status' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when user is not logged' do
      before do
        delete "/api/v1/activities/delete/#{activity.id}"
      end

      it 'should return found status' do
        expect(response).to have_http_status(:found)
      end

      it 'should not delete activity' do
        expect(Activity.find_by(id: activity.id)).to_not be_nil
      end
    end
  end
end
