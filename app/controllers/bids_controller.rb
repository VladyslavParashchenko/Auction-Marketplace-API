# frozen_string_literal: true

require "api/bids_controller"
class BidsController < ApplicationController
  include BidDocs

  def create
    bid = Lot.find(params[:lot_id]).bids.create(bid_params)
    render_item(bid)
  end

  def show
    bid = Bid.find(params[:id])
    render_item(bid)
  end

  private

  def bid_params
    params.permit(:proposed_price).merge(user_id: current_user.id)
  end
end
