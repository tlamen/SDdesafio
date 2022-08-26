# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    name { "MyString" }
    description { "MyString" }
    start { "2022-08-25 18:21:43" }
    duration { 1 }
    category { create(:category) }
    user { create(:user) }
  end
end
