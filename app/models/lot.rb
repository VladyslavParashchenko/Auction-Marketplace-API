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
  validate :is_status_pending, on: :create
  after_create :add_jobs
  after_update :recreate_jobs
  before_destroy :delete_jobs
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
    if status != "pending"
      errors.add :status, "Lot can be created only with status pending"
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
      lots = Lot.joins(:bids).where(bids: {user_id: user_id})
    end
    lots
  end

  def update_price(proposed_price)
    update(current_price: proposed_price)
  end

  def delete_jobs
    jobs = Sidekiq::ScheduledSet.new.take(Sidekiq::ScheduledSet.new.size)
    jobs_jid_for_deleting = []
    jobs.each do |job|
      job_values = json_parse(job.value)
      if (job_values["args"].first["arguments"][0] == id) && (job_values["wrapped"] == "StatusHandlerJob")
        jobs_jid_for_deleting << job_values["jid"]
      end
    end
    jobs_jid_for_deleting.each do |jid|
      job_for_deleting = Sidekiq::ScheduledSet.new.find_job(jid)
      job_for_deleting.delete
    end

  end

  def add_jobs
    StatusHandlerJob.set(wait_until: lot_start_time).perform_later(id, "in_process")
    StatusHandlerJob.set(wait_until: lot_end_time).perform_later(id, "closed")
  end

  def recreate_jobs
    delete_jobs
    add_jobs
  end
end
