# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  bid_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_orders_on_bid_id  (bid_id)
#

class Order < ApplicationRecord
  has_one :bid
end
