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

class Order < ApplicationRecord
  belongs_to :bid
  has_one :lot, through: :bid
  has_one :user, through: :bid
  enum status: { pending: 0, sent: 1, delivered: 2 }
  enum arrival_type: { pickup: 0, delivery_company: 1 }
  validates :arrival_location, presence: true
  validates :arrival_type, presence: true
  validate :validate_bid_status
  after_update :send_notification_to_seller, if: :saved_change_to_status?

  private

    def validate_bid_status
      unless bid.lot.closed?
        errors.add :bid_status, "You can create order only for closed lot"
      end
    end

    def send_notification_to_seller
      if sent?
        NotificationMailer.send_customer_lot_sent(self).deliver_now
      elsif delivered?
        NotificationMailer.send_seller_order_create(self).deliver_now
      end
    end
end
