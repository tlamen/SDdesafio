# frozen_string_literal: true

FactoryBot.define do
  sequence :emails do |e|
    "user#{e}@mail.com"
  end

  factory :user do
    email { generate(:emails) }
    password { '123456' }
    name { 'string' }
    birthdate { '25-12-2001' }
    role { 3 }
  end
end
