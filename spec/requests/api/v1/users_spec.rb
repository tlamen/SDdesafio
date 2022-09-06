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

  describe 'POST /register' do
    let(:client_params) do
      {
        name: 'client',
        email: 'test_client@mail.com',
        password: '123456',
        birthdate: '01-01-2000',
        role: 3
      }
    end

    let(:teacher_params) do
      {
        name: 'teacher',
        email: 'test_teacher@mail.com',
        password: '123456',
        birthdate: '01-01-1990',
        role: 2
      }
    end

    let(:admin_params) do
      {
        name: 'admin',
        email: 'test_admin@mail.com',
        password: '123456',
        birthdate: '01-01-1990',
        role: 1
      }
    end

    context 'when provided valid params for client user' do
      before { post '/api/v1/users/register', params: { user: client_params } }

      it 'should return created status' do
        expect(response).to have_http_status(:created)
      end

      it 'should have saved the user' do
        new_user = User.find_by(email: 'test_client@mail.com')
        expect(new_user).to_not be_nil
      end

      it 'should have client role' do
        new_user = User.find_by(email: 'test_client@mail.com')
        expect(new_user.role).to eq(3)
      end
    end

    context 'when provided valid params for teacher user' do
      before { post '/api/v1/users/register', params: { user: teacher_params } }

      it 'should return created status' do
        expect(response).to have_http_status(:created)
      end

      it 'should have saved the user' do
        new_user = User.find_by(email: 'test_client@mail.com')
        expect(new_user).to_not be_nil
      end

      it 'should have teacher role' do
        new_user = User.find_by(email: 'test_client@mail.com')
        expect(new_user.role).to eq(2)
      end
    end

    context 'when provided valid params for admin user' do
      before { post '/api/v1/users/register', params: { user: admin_params } }

      it 'should return created status' do
        expect(response).to have_http_status(:created)
      end

      it 'should have saved the user' do
        new_user = User.find_by(email: 'test_client@mail.com')
        expect(new_user).to_not be_nil
      end

      it 'should have admin role' do
        new_user = User.find_by(email: 'test_client@mail.com')
        expect(new_user.role).to eq(1)
      end
    end

    context 'when params are not valid' do
      before { post '/api/v1/users/register/user', params: { user: { name: 'invalid', email: 'invalid@mail.com'} } }
      
      it 'should return unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end 

      it 'should not have saved the user' do
        new_user = User.find_by(email: 'invalid@mail.com')
        expect(new_user).to be_nil
      end
    end
  end

  describe 'GET /index' do
    before do
      create(:user, email: 'email1@mail.com')
      create(:user, email: 'email2@mail.com')
      get '/api/v1/users/index'
    end
    it 'should returns http ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'should return 2 users' do
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'GET /show' do
    let(:user) { create(:user) }

    context 'when user exists' do
      before { get "/api/v1/users/show/#{user.id}" }
      it { expect(response).to have_http_status(:ok) }
    end

    context 'when user does not exists' do
      before do
        user.destroy!
        get "/api/v1/users/show/#{usuario.id}"
      end
      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'PUT /update' do
    let(:user) { create(:user) }

    context 'when user exists and params are valid' do
      before do
        put "/api/v1/users/update/#{user.id}", params: {
          user: { name: 'new name' }
        }, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        user.reload
      end

      it 'should have changed user name' do
        expect(user.name).to eq('new name')
      end

      it 'should return ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user does not exists' do
      before do
        user.destroy!
        put "/api/v1/users/update/#{user.id}", params: {
          user: { name: 'new name' }
        }, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        user.reload
      end

      it 'should return not_found status' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when params are invalid' do
      before do
        put "/api/v1/users/update/#{user.id}", params: {
          user: { email: 'bad address' }
        }, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        user.reload
      end

      it 'should return bad_request status' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when user is not logged' do
      before do
        put "/api/v1/users/update/#{user.id}", params: {
          user: { name: 'new name' }
        }
        user.reload
      end

      it 'should return unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /delete' do
    let(:user) { create(:user) }

    context 'when user exists' do
      before do
        delete "/api/v1/users/delete/#{user.id}"
      end

      it 'should return ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'should have deleted user' do
        expect(User.where(id: user.id)).to eq([])
      end
    end

    context 'when user does not exists' do
      before do
        user.destroy!
        delete "/api/v1/users/delete/#{user.id}"
      end

      it 'should return not_found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
