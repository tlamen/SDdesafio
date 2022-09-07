# frozen_string_literal: true

module Api
  module V1
    class RegistrationController < ApplicationController
      def index
        registrations = Registration.all
        render json: registrations, status: :ok
      rescue StandardError => e
        render json: { message: e.message }, status: :bad_request
      end

      def create
        registration = Registration.create!(registration_params)
        render json: registration, status: :created
      rescue StandardError => e
        render json: { message: e.message }, status: :bad_request
      end

      def delete
        registration = Registration.find(params[:id])
        registration.destroy!
        render json: registration, status: :ok
      rescue StandardError => e
        render json: { message: e.message }, status: :bad_request
      end

      private

      def registration_params
        params.require(:registration).permit(
          :user_id,
          :activity_id
        )
      end 
    end
  end
end
