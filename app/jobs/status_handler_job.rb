# frozen_string_literal: true

class StatusHandlerJob < ApplicationJob
  queue_as :default

  def perform(lot_id, status)
    lot = Lot.find(lot_id)
    lot.update(status: status) if (jid == lot.start_jid) || (jid == lot.end_jid)
  end
end
