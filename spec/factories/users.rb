# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  birthday   :datetime
#  email      :string
#  first_name :string
#  last_name  :string
#  password   :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.phone_number }
    birthday { Faker::Date.birthday 21, 100 }
  end
  factory :young_user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.phone_number }
    birthday { Faker::Date.birthday 8, 20 }
  end
end
