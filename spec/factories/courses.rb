# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    name { 'MyString' }
    description { 'MyString' }
    start_time { '18:00:00' }
    week_day { 'Monday' }
    duration { 1 }
    category_id { 1 }
    user_id { 1 }
  end
end
