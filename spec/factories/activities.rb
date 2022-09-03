FactoryBot.define do
  factory :activity do
    name { "MyString" }
    description { "MyString" }
    duration { 1 }
    category { create(:category) }
    user { create(:user) }
    week_day { "MyString" }
    start_time { "2022-09-03 16:08:09" }
  end
end
