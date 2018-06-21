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
  enum status: { pending: 0, in_process: 1, closed: 2 }
  validates :title, presence: true
  validates :current_price, presence: true, numericality: { greater_than: 0 }
  validates :estimated_price, presence: true, numericality: { greater_than: 0 }
  validate :validate_start_time
  validate :validate_end_time
  validate :is_status_pending, on: :create
  after_create :add_jobs
  after_update :recreate_jobs
  after_update :send_mail_if_closed, if: :saved_change_to_status?
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

  def is_status_pending
    unless pending?
      errors.add :status, "Lot can be created only with status pending"
    end
  end
  mount_uploader :image, ImageUploader

  def self.filter_my_lot(filter, user)
    # puts user_id.id
    case filter
    when "all"
      Lot.left_outer_joins(:bids).where("bids.user_id": user.id).or(Lot.left_outer_joins(:bids).where("lots.user_id": user.id))
    when "created"
      Lot.where(user_id: user.id)
    when "participation"
      Lot.joins(:bids).where(bids: { user_id: user.id })
    end
  end

  def update_price(proposed_price)
    update(current_price: proposed_price)
  end

  def find_winner
    bids.order("proposed_price desc").first.user
  end

  def find_winner_bid
    bids.order("proposed_price").last
    end

  def find_winner_order
    bids.order("proposed_price").last.order
  end
  def close_lot
    update_column(:start_jid, "")
    update_column(:end_jid, "")
    update(status: :closed)
  end
  private

    def add_jobs
      new_start_jid = StatusHandlerJob.set(wait_until: lot_start_time).perform_later(id, "in_process").provider_job_id
      new_end_jid = StatusHandlerJob.set(wait_until: lot_end_time).perform_later(id, "closed").provider_job_id
      update_column(:start_jid, new_start_jid)
      update_column(:end_jid, new_end_jid)
    end

    def recreate_jobs
      add_jobs
    end

    def send_mail_if_closed
      if closed?
        NotificationMailer.send_seller_lot_purchased(find_winner_bid).deliver_now
      end
    end
end
