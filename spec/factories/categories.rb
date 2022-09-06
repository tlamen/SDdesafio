# frozen_string_literal: true

FactoryBot.define do
  sequence :names do |e|
    "Categoria#{e}"
  end

  factory :category do
    name { generate(:names) }
    description { 'MyString' }
  end
end
