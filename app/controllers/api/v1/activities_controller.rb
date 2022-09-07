# frozen_string_literal: true

module Api
  module V1
    class ActivitiesController < ApplicationController
      acts_as_token_authentication_handler_for User, only: %i[create update delete]

      def index
        activities = Activity.all
        render json: activities, status: :ok
      rescue StandardError => e
        render json: { message: e.message }, status: :bad_request
      end

      def show
        activity = Activity.find(params[:id])
        render json: activity, status: :ok
      rescue StandardError => e
        render json: { message: e.message }, status: :not_found
      end

      def create
        if currrent_user.role != 3
          activity = Activity.create!(activity_params)
          render json: activity, status: :created          
        else
          render json: { message: "unauthorized" }, status: :unauthorized
        end
      rescue StandardError => e
        render json: { message: e.message }, status: :unprocessable_entity
      end

      def update
        
      end
      
      def delete
        
      end

      private

      def activity_params
        params.require(:activity).permit(
          :name,
          :description,
          :duration,
          :category_id,
          :user_id,
          :week_day,
          :start_time
        )
      end
    end
  end
end
