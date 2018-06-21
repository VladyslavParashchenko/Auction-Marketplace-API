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

class Bid < ApplicationRecord
  belongs_to :user
  has_one :order
  belongs_to :lot
  validates :proposed_price, presence: true, numericality: { greater_than: 0 }
  validate :validate_proposed_price
  after_create :broadcast_new_bid
  after_create :change_current_price
  after_create :check_is_price_greater_than_estimated
  def broadcast_new_bid
    ActionCable.server.broadcast("lot##{lot_id}", BidActiveCableSerializer.new(self).as_json)
  end

  def validate_proposed_price
    current_price = lot.current_price
    if current_price >= proposed_price
      errors.add :proposed_price, "proposed price must be higher than the previous one"
    end
  end
  def change_current_price
    lot.update_price(proposed_price)
  end

  def check_is_price_greater_than_estimated
    if proposed_price >= lot.estimated_price
      lot.close_lot
    end
  end
end
