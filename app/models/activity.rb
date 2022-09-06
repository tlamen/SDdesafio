# frozen_string_literal: true

class Activity < ApplicationRecord
  belongs_to :category
  belongs_to :user

  validates_presence_of :name, :description, :week_day, :start_time, :duration
  validates :week_day,
            acceptance: { accept: %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday] }
  validates :duration, numericality: { greater_than: 0 }
end
