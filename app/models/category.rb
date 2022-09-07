# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :activities, dependent: :destroy

  validates_presence_of :name, :description
  validates :name, uniqueness: true
end
