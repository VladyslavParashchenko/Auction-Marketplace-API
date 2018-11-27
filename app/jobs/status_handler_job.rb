# frozen_string_literal: true

class StatusHandlerJob < ApplicationJob
  queue_as :default

  def perform(lot_id, status)
    lot = Lot.find(lot_id)
    if (self.jid == lot.start_jid) || (self.jid == lot.end_jid)
      lot.update(status: status)
    end
  end
end
