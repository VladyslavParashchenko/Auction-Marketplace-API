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

require "carrierwave/orm/activerecord"
class Lot < ApplicationRecord
  belongs_to :user
  has_many :bids, dependent: :destroy
  has_one :order, through: :bids
  enum status: {pending: 0, in_process: 1, closed: 2}
  validates :title, presence: true
  validates :current_price, presence: true, numericality: {greater_than: 0}
  validates :estimated_price, presence: true, numericality: {greater_than: 0}
  validate :validate_start_time
  validate :validate_end_time

  def validate_start_time
    if lot_start_time < Time.now
      errors.add :lot_start_time, "start time cannot be less than current time"
    end
  end

  def validate_end_time
    if lot_end_time < lot_start_time
      errors.add :lot_end_time, "end time cannot be less than start time"
    end
  end

  mount_uploader :image, ImageUploader

  def self.filter_my_lot(filter, user_id)
    case filter
    when "all"
      lots = Lot.left_outer_joins(:bids).where("bids.user_id": user_id).or(Lot.left_outer_joins(:bids).where("lots.user_id": user_id))
    when "created"
      lots = Lot.where(user_id: user_id)
    when "participation"
      lots = Lot.joins(:bids).where(bids: { user_id: user_id })
    end
    lots
  end
  def update_price(proposed_price)
    update(current_price: proposed_price)
  end
end
