# frozen_string_literal: true

FactoryBot.define do
  factory :activity do
    name { 'MyString' }
    description { 'MyString' }
    duration { 1 }
    category { create(:category) }
    user { create(:user) }
    week_day { 'Monday' }
    start_time { '2022-09-03 16:08:09' }
  end
end
