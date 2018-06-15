class StatusHandlerJob < ApplicationJob
  queue_as :default

  def perform(lot_id, status)
    Lot.find(lot_id).update(status: status)
    if status == "closed"
      LotWinnerMailer.send_mail_to_lot_winner(Lot.find(lot_id)).deliver_now
    end
  end
end

