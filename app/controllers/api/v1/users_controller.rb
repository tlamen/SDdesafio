# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      acts_as_token_authentication_handler_for User, only: %i[logout update delete]

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

      def index
        users = User.all
        render json: users, status: :ok
      rescue StandardError => e
        render json: { message: e.message }, status: :bad_request
      end

      def show
        user = User.find(params[:id])
        render json: user, status: :ok
      rescue StandardError => e
        render json: { message: e.message }, status: :not_found
      end

      def register
        user = User.create!(user_params)
        render json: user, status: :created
      rescue StandardError => e
        render json: { message: e.message }, status: :unprocessable_entity
      end

      def update
        user = User.find(params[:id])
        user.update!(user_params)
        user.save!
        render json: user, status: :ok
      rescue StandardError => e
        render json: { message: e.message }, status: :bad_request
      end

      def delete
        user = User.find(params[:id])
        user.destroy!
        render json: user, status: :ok
      rescue StandardError => e
        render json: { message: e.message }, status: :not_found
      end

      private

      def user_params
        params.require(:user).permit(
          :email,
          :password,
          :name,
          :birthdate,
          :role
        )
      end
    end
  end
end
