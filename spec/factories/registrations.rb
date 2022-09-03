# frozen_string_literal: true

FactoryBot.define do
  factory :registration do
    user { create(:user) }
    activity { create(:activity) }
  end
end
