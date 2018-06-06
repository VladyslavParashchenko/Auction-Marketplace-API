# == Schema Information
#
# Table name: lots
#
#  id              :bigint(8)        not null, primary key
#  current_price   :decimal(8, 2)
#  description     :text
#  estimated_price :decimal(8, 2)
#  lot_end_time    :datetime
#  lot_image       :json
#  lot_start_time  :datetime
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
    id {Faker::Number.number(3)}
    title {"Лот #" + Faker::Number.number(3)}
    current_price {1289.94}
    estimated_price {2500}
    trait :valid_start_and_end_time do
      lot_start_time {Faker::Time.between(2.days.from_now, 80.days.from_now)}
      lot_end_time {Faker::Time.between(100.days.from_now, 180.days.from_now)}
    end
    trait :not_valid_start_time do
      lot_start_time {Faker::Time.between(2.days.ago, 80.days.ago)}
      lot_end_time {Faker::Time.between(100.days.from_now, 180.days.from_now)}
    end
    trait :not_valid_end_time do
      lot_start_time {Faker::Time.between(50.days.from_now, 80.days.from_now)}
      lot_end_time {Faker::Time.between(2.days.from_now, 50.days.from_now)}
    end
    trait :lot_image do
      lot_image {File.new(File.join(::Rails.root.to_s, "spec/fixtures/files/", "test.jpg"))}
    end
  end
end
