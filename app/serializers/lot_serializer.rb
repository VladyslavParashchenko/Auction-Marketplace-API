# == Schema Information
#
# Table name: lots
#
#  id              :bigint(8)        not null, primary key
#  current_price   :decimal(8, 2)
#  description     :text
#  estimated_price :decimal(8, 2)
#  image           :string
#  lot_end_time    :datetime
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

class LotSerializer < ActiveModel::Serializer
  attributes :id, :title, :current_price, :estimated_price,
             :lot_start_time, :lot_end_time, :status, :image, :description
  attribute :is_current_user_lot?
  has_one :user
  has_many :bids
  def is_current_user_lot?
    unless current_user.nil?
      current_user.lots.find_by_id(:id).nil?
    end
  end
  class BidSerializer < ActiveModel::Serializer
    attributes :proposed_price, :created_at
    attribute :user do
      number  = @instance_options[:sequence].number
      if current_user.id == object.user_id
        username = "You"
      else
        username = "Customer #{number}"
      end
      username
    end
  end

end
