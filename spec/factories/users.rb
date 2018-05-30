# frozen_string_literal: true

FactoryBot.define do
  factory :adult_user, class: User do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    phone Faker::PhoneNumber.phone_number
    birthday Faker::Date.birthday 21, 100
    end
  factory :young_user, class: User do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    phone Faker::PhoneNumber.phone_number
    birthday Faker::Date.birthday 8, 20
  end
end