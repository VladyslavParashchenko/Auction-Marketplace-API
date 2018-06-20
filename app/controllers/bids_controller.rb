class BidsController < ApplicationController
  def create
    bid = Lot.find(params[:lot_id]).bids.new(bid_params)
    if bid.save
      ActionCable.server.broadcast("lot##{bid.lot.id}", BidActiveCableSerializer.new(bid, :current_user=>current_user.id).as_json)
      bid.lot.update_price(bid.proposed_price)
    end
    render_item(bid)
  end
  def show
    bid = Bid.find(params[:id])
    render_item(bid)
  end

  private

  def bid_params
    params.permit(:proposed_price).merge({user_id: current_user.id})
  end
end
