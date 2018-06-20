class OrderController < ApplicationController
  def create
    @bid = Lot.find(params[:lot_id]).find_winner_bid
    order = Order.new(order_params)
    order.save
    render_item(order)
  end

  def update
    lot = Lot.find(params[:lot_id])
    order = lot.find_winner_order
    order.update(order_status)
    render_item(order)
  end

  private

  def order_params
    params.permit(:arrival_type, :arrival_location, :delivery_company).merge({bid_id: @bid.id})
  end

  def order_status
    params.permit(:status)
  end
end
