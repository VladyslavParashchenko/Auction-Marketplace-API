class StatusHandlerJob < ApplicationJob
  queue_as :default

  def perform(lot_id, status)
    if (self.jid == Lot.find(lot_id).start_jid) || (self.jid == Lot.find(lot_id).end_jid)
      Lot.find(lot_id).update(status: status)
    end
  end
end

