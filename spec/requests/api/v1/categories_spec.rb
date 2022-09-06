# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Categories', type: :request do
  let(:client) { create(:user, role: 3) }
  let(:teacher) { create(:user, role: 2) }
  let(:admin) { create(:user, role: 1) }

  describe 'GET /index' do
    before do
      create(:category, name: 'category 1')
      create(:category, name: 'category 2')
      get '/api/v1/categories/index'
    end

    it 'should return ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'should return 2 categories' do
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'GET /show' do
    let(:category) { create(:category) }
    
    context 'when category exists' do
      before { get "/api/v1/categories/show/#{category.id}" }
      
      it 'should have ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when category does not exists' do
      before do
        category.destroy!
        get "/api/v1/categories/show/#{category.id}"
      end

      it 'should have not_found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /create' do
    let(:valid_params) do
      {
        name: 'new category',
        description: 'category created for tests'
      }
    end

    context 'when client uses valid params' do
      before do
        post "/api/v1/categories/create", params: { category: valid_params },
        headers: {
          'X-User-Email': client.email,
          'X-User-Token': client.authentication_token
        }
      end

      it 'should return unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'should not have saved the category' do
        new_category = Category.find_by(name: 'new category')
        expect(new_category).to be_nil
      end
    end

    context 'when teacher uses valid params' do
      before do
        post "/api/v1/categories/create", params: { category: valid_params },
        headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
      end

      it 'should return created status' do
        expect(response).to have_http_status(:created)
      end

      it 'should have saved the category' do
        new_category = Category.find_by(name: 'new category')
        expect(new_category).to_not be_nil
      end
    end

    context 'when admin uses valid params' do
      before do
        post "/api/v1/categories/create", params: { category: valid_params },
        headers: {
          'X-User-Email': admin.email,
          'X-User-Token': admin.authentication_token
        }
      end

      it 'should return created status' do
        expect(response).to have_http_status(:created)
      end

      it 'should have saved the category' do
        new_category = Category.find_by(name: 'new category')
        expect(new_category).to_not be_nil
      end
    end

    context 'when params are not valid' do
      before do
        post "/api/v1/categories/create", params: { category: { name: 'no description', description: nil } },
        headers: {
          'X-User-Email': admin.email,
          'X-User-Token': admin.authentication_token
        }
      end

      it 'should return unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should not have saved the category' do
        new_category = Category.find_by(name: 'no description')
        expect(new_category).to be_nil
      end
    end

    context 'when user is not logged' do
      before do
        post "/api/v1/categories/create", params: { category: valid_params }
      end

      it 'should return unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'should not have saved the category' do
        new_category = Category.find_by(name: 'new category')
        expect(new_category).to be_nil
      end
    end
  end

  describe 'PUT /update' do
    let(:category) { create(:category) }

    context 'when client uses valid params' do
      before do
        put "/api/v1/categories/update/#{category.id}", params: {
          category: { name: 'new name' }
        }, headers: {
          'X-User-Email': client.email,
          'X-User-Token': client.authentication_token
        }
        category.reload
      end

      it 'should return unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'should not update category' do
        expect(category.name).to_not eq('new name')
      end
    end

    context 'when teacher uses valid params' do
      before do
        put "/api/v1/categories/update/#{category.id}", params: {
          category: { name: 'new name' }
        }, headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
        category.reload
      end

      it 'should return ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'should update category' do
        expect(category.name).to eq('new name')
      end
    end

    context 'when admin uses valid params' do
      before do
        put "/api/v1/categories/update/#{category.id}", params: {
          category: { name: 'new name' }
        }, headers: {
          'X-User-Email': admin.email,
          'X-User-Token': admin.authentication_token
        }
        category.reload
      end

      it 'should return ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'should update category' do
        expect(category.name).to eq('new name')
      end
    end

    context 'when category does not exists' do
      before do
        category.destroy!
        put "/api/v1/categories/update/#{category.id}", params: {
          category: { name: 'new name' }
        }, headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
        category.reload
      end

      it 'should return not_found status' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when params are not valid' do
      before do
        put "/api/v1/categories/update/#{category.id}", params: {
          category: { name: '' }
        }, headers: {
          'X-User-Email': teacher.email,
          'X-User-Token': teacher.authentication_token
        }
        category.reload
      end

      it 'should return bad_request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'should not update category' do
        expect(category.name).to_not eq('')
      end
    end

    context 'when user is not logged' do
      before do
        put "/api/v1/categories/update/#{category.id}", params: {
          category: { name: 'new name' }
        }
        category.reload
      end

      it 'should return unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'should not update category' do
        expect(category.name).to_not eq('new name')
      end
    end
  end

  describe 'DELETE /delete' do
    let(:category) { create(:category) }

    context 'when client tries to delete' do
      before do
        delete "/api/v1/categories/delete/#{category.id}", headers: {
          'X-User-Email': client.email,
          'X-User-Token': client.authentication_token
        }
      end

      it 'should return unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'should not delete category' do
        expect(Category.find_by(id: category.id)).to_not be_nil 
      end
    end
  end

  context 'when teacher tries to delete' do
    before do
      delete "/api/v1/categories/delete/#{category.id}", headers: {
        'X-User-Email': teacher.email,
        'X-User-Token': teacher.authentication_token
      }
    end

    it 'should return ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'should delete category' do
      expect(Category.find_by(id: category.id)).to be_nil 
    end
  end

  context 'when admin tries to delete' do
    before do
      delete "/api/v1/categories/delete/#{category.id}", headers: {
        'X-User-Email': admin.email,
        'X-User-Token': admin.authentication_token
      }
    end

    it 'should return ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'should delete category' do
      expect(Category.find_by(id: category.id)).to be_nil 
    end
  end
  context 'when category does not exists' do
    before do
      category.destroy!
      delete "/api/v1/categories/delete/#{category.id}", headers: {
        'X-User-Email': teacher.email,
        'X-User-Token': teacher.authentication_token
      }
    end

    it 'should return not_found status' do
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when user is not logged' do
    before do
      delete "/api/v1/categories/delete/#{category.id}"
    end

    it 'should return unauthorized status' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should not delete category' do
      expect(Category.find_by(id: category.id)).to_not be_nil 
    end
  end
end
