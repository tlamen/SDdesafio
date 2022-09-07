# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace 'api' do
    namespace 'v1' do
      scope 'users' do
        post '/login', to: 'users#login'
        post '/logout', to: 'users#logout'
        get '/index', to: 'users#index'
        get '/show/:id', to: 'users#show'
        post '/register', to: 'users#register'
        put '/update/:id', to: 'users#update'
        delete '/delete/:id', to: 'users#delete'
      end

      scope 'categories' do
        get '/index', to: 'categories#index'
        get '/show/:id', to: 'categories#show'
        post '/create', to: 'categories#create'
        put '/update/:id', to: 'categories#update'
        delete '/delete/:id', to: 'categories#delete'
      end
    end
  end
end
