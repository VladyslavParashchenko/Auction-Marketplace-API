# frozen_string_literal: true

# == Schema Information
#
# Table name: bids
#
#  id             :bigint(8)        not null, primary key
#  proposed_price :decimal(8, 2)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  lot_id         :bigint(8)
#  user_id        :bigint(8)
#
# Indexes
#
#  index_bids_on_lot_id   (lot_id)
#  index_bids_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_c8d521b062  (lot_id => lots.id)
#  fk_rails_e173de2ed3  (user_id => users.id)
#

FactoryBot.define do
  factory :bid, class: Bid do
    proposed_price { self.lot.current_price.to_f + Faker::Number.decimal(4, 2).to_f }
    association :lot, factory: :lot
    association :user, factory: :client
  end
end
