class BidChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lot##{params[:lot_id]}"
  end
  def unsubscribed
  end
end