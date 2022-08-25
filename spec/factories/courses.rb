FactoryBot.define do
  factory :course do
    name { "MyString" }
    description { "MyString" }
    start { "2022-08-25 18:21:43" }
    duration { 1 }
    category_id { nil }
    teacher_id { nil }
  end
end
