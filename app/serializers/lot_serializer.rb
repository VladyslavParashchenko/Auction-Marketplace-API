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
#  winner_bid      :integer
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
#  fk_rails_6897db8a79  (winner_bid => bids.id)
#  fk_rails_7afc1a8e38  (user_id => users.id)
#

class LotSerializer < ActiveModel::Serializer
  attributes :id, :title, :current_price, :estimated_price,
             :lot_start_time, :lot_end_time, :status, :image, :description, :is_user_lot, :lot_order, :winner_bid
  has_one :user
  has_many :bids, sequence: Helpers::Sequence.new
  def is_user_lot
    current_user.id == object.user.id
  end

  def lot_order
    unless object.winner_bid.nil?
      OrderSerializer.new(object.get_winner_bid.order).as_json
    end
  end
end
