class Api::V1::RegistrationController < ApplicationController
    acts_as_token_authentication_handler_for User
end
