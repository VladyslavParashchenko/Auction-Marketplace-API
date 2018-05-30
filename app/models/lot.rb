# == Schema Information
#
# Table name: lots
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint(8)
#
# Indexes
#
#  index_lots_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_7afc1a8e38  (user_id => users.id)
#
class Lot < ApplicationRecord
  belongs_to :user
  has_many :bids, dependent: :destroy
  has_one :order, through: :bids
end
