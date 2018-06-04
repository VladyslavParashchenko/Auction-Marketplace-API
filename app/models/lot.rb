# frozen_string_literal: true
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
#  status          :integer          default(0)
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

class Lot < ApplicationRecord
  belongs_to :user
  has_many :bids, dependent: :destroy
  has_one :order, through: :bids
  enum status: { pending: 0, in_process: 1, closed: 2 }
  validates :title, presence: true
  validates :current_price, presence: true
  validates :estimated_price, presence: true,
end
