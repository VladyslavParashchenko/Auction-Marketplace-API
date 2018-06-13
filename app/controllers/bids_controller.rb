class BidsController < ApplicationController
  def create
    lot = Lot.find(params[:lot_id])
    bid = lot.bids.new(bid_params)
    bid.user_id = current_user.id
    bid.save
    render_item(bid)
  end
  def show
    bid = Bid.find(params[:id])
    render_item(bid)
  end

  private

  def bid_params
    params.permit(:proposed_price)
  end
end
