# == Schema Information
#
# Table name: orders
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bid_id     :bigint(8)
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
end
