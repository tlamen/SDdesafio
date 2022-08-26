# frozen_string_literal: true

FactoryBot.define do
  factory :registration do
    user { create(:user) }
    course { create(:course) }
  end
end
