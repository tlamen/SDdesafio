# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApplicationController
      acts_as_token_authentication_handler_for User, only: %i[create update delete]
      
      def index
        categories = Category.all
        render json: categories, status: :ok
      rescue StandardError => e
        render json: { message: e.message }, status: :bad_request
      end

      def show
        category = Category.find(params[:id])
        render json: category, status: :ok
      rescue StandardError => e
        render json: { message: e.message }, status: :not_found
      end

      def create
        if current_user.role != 3
          category = Category.create!(category_params)
          render json: category, status: :created
        else
          render json: { message: "unauthorized"}, status: :unauthorized
        end
      rescue StandardError => e
        render json: { message: e.message }, status: :unprocessable_entity
      end

      def update
        if current_user.role != 3
          category = Category.find(params[:id])
          category.update!(category_params)
          category.save!
          render json: category, status: :ok
        else
          render json: { message: "unauthorized"}, status: :unauthorized
        end
      rescue StandardError => e
        render json: { message: e.message }, status: :bad_request
      end

      def delete
        if current_user.role != 3
          category = Category.find(params[:id])
          category.destroy!
          render json: category, status: :ok
        else
          render json: { message: "unauthorized"}, status: :unauthorized
        end
      rescue StandardError => e
        render json: { message: e.message }, status: :bad_request
      end

      private

      def category_params
        params.require(:category).permit(
          :name,
          :description
        )
      end
    end
  end
end
