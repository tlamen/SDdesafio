# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'POST /login' do
    let(:usuario) { create(:user) }

    context 'when user exists' do
      before do
        post '/api/v1/users/login', params: { email: usuario.email, password: usuario.password }
      end

      it 'should return ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user does not exists' do
      before { post '/api/v1/users/login', params: { email: 'naoexiste@email', password: '123456' } }
      it 'should return not found status' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user handles wrong password' do
      before { post '/api/v1/users/login', params: { email: usuario.email, password: nil } }
      it 'should return unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /logout' do
    let(:usuario) { create(:user) }
    let(:antigo_token) { usuario.authentication_token }

    context 'when user is logged' do
      before do
        post '/api/v1/users/logout', headers: {
          'X-User-Email': usuario.email,
          'X-User-Token': antigo_token
        }
        usuario.reload
      end

      it 'should return no_content status' do
        expect(response).to have_http_status(:ok)
      end

      it 'should change user authentication token' do
        expect(usuario.authentication_token).to_not eq(antigo_token)
      end
    end

    context 'when user is not logged' do
      before do
        post '/api/v1/users/logout'
        usuario.reload
      end

      it 'should not change user authentication token' do
        expect(usuario.authentication_token).to eq(antigo_token)
      end
    end
  end
end
