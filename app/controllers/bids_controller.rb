require "helpers/render_helper"
class BidsController < ApplicationController
  def create
    lot = Lot.find_by_id(params[:lot_id])
    if lot.nil?
      render_error(params, { error: "Lot not found" }, 404)
    else
      bid = lot.bids.new(bid_params)
      bid.user_id = current_user.id
      if bid.save
        render_item(bid)
      else
        render_error(params, bid.errors, 400)
      end
    end
  end
  def show
    bid = Bid.find_by_id(params[:id])
    if bid.nil?
      render_error(params, { error: "Lot not found" }, 404)
    else
      render_item(bid)
    end
  end

  private

  def bid_params
    params.permit(:id, :proposed_price, :lot_id)
  end
end
