# frozen_string_literal: true

# == Schema Information
#
# Table name: lots
#
#  id              :bigint(8)        not null, primary key
#  current_price   :decimal(8, 2)
#  description     :text
#  end_jid         :string
#  estimated_price :decimal(8, 2)
#  image           :string
#  lot_end_time    :datetime
#  lot_start_time  :datetime
#  start_jid       :string
#  status          :integer          default("pending")
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint(8)
#
# Indexes
#
#  index_lots_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_7afc1a8e38  (user_id => users.id)
#

FactoryBot.define do
  factory :lot, class: Lot do
    title { "Лот #" + Faker::Number.number(3) }
    current_price { Faker::Number.number(4).to_f }
    estimated_price { Faker::Number.number(6).to_f }
    lot_start_time { Faker::Time.between(2.days.from_now, 80.days.from_now) }
    lot_end_time { Faker::Time.between(100.days.from_now, 180.days.from_now) }
    trait :not_valid_start_time do
      lot_start_time { Faker::Time.between(2.days.ago, 80.days.ago) }
      lot_end_time { Faker::Time.between(100.days.from_now, 180.days.from_now) }
    end
    trait :not_valid_end_time do
      lot_start_time { Faker::Time.between(50.days.from_now, 80.days.from_now) }
      lot_end_time { Faker::Time.between(2.days.from_now, 50.days.from_now) }
    end
    trait :lot_image do
      image { Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "files", "test.jpg"), "image/jpeg") }
    end
    status { :pending }
    association :user, factory: :client
  end
end
