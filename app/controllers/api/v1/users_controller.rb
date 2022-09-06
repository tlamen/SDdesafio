class Api::V1::UsersController < ApplicationController
    def login
        user = User.find_by!(email: params[:email])
        if user.valid_password?(params[:password])
            user.update! authentication_token: nil # Metodo para corrigir erro com token de autenticacao
            render json: user
        else
            head status: :unauthorized
        end
    rescue StandardError => e
        render json: { message: e.message }, status: :not_found
    end 
end
