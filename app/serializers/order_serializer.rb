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

class OrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :arrival_location, :arrival_type, :bid_id, :delivery_company
  attribute :customer_id
  attribute :seller_id


  def customer_id
    object.bid.user.id
  end

  def seller_id
    object.bid.lot.user.id
  end
end
