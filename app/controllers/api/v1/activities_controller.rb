class Api::V1::ActivitiesController < ApplicationController
    acts_as_token_authentication_handler_for User
end
