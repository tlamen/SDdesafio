# frozen_string_literal: true

class Course < ApplicationRecord
  belongs_to :category_id
  belongs_to :user_id
end
