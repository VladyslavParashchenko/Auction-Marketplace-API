# frozen_string_literal: true

require "api/order_controller"
class OrderController < ApplicationController
  include OrderDocs

  def create
    order = Order.create(order_params(Lot.find(params[:lot_id])))
    render_item(order)
  end

  def update
    order = Lot.find(params[:lot_id]).find_winner_order
    order.update(order_status)
    render_item(order)
  end

  private

    def order_params(lot)
      params.permit(:arrival_type, :arrival_location, :delivery_company).merge(bid_id: lot.find_winner_bid.id)
    end

    def order_status
      params.permit(:status)
    end
end
