# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      acts_as_token_authentication_handler_for User, only: [:logout]

      def login
        user = User.find_by!(email: params[:email])
        if user.valid_password?(params[:password])
          user.update! authentication_token: nil # Metodo para corrigir erro com token de autenticacao
          render json: user, status: :ok
        else
          head(:unauthorized)
        end
      rescue StandardError => e
        render json: { message: e.message }, status: :not_found
      end

      def logout
        current_user.authentication_token = nil
        current_user.save!
        head(:ok)
      rescue StandardError => e
        render json: { message: e.message }, status: :bad_request
      end
    end
  end
end
