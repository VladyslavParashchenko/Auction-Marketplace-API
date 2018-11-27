# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id               :bigint(8)        not null, primary key
#  arrival_location :string
#  arrival_type     :integer
#  delivery_company :string
#  status           :integer          default("pending")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  bid_id           :bigint(8)
#
# Indexes
#
#  index_orders_on_bid_id  (bid_id)
#
# Foreign Keys
#
#  fk_rails_70594f7ad3  (bid_id => bids.id)
#

FactoryBot.define do
  factory :order, class: Order do
    arrival_location { Faker::Address.full_address }
    arrival_type :delivery_company
    delivery_company { Faker::Company.name }
    association :bid, factory: :bid
  end
end
