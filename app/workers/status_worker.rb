# frozen_string_literal: true

class StatusWorker
  include Sidekiq::Worker
  queue_as :status_queue
  def perform(lot_id, status)
    Lot.find(lot_id).update(status: status)
  end
end
