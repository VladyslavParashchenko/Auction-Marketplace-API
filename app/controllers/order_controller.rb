# frozen_string_literal: true

require "api/order_controller"
class OrderController < ApplicationController
  include OrderDocs
  def create
    order = Order.new(order_params)
    authorize(order)
    order.save
    render_item(order)
  end

  def update
    order = Order.find(params[:id])
    authorize(order)
    order.update(order_status)
    render_item(order)
  end

  private

    def order_params
      params.permit(:arrival_type, :arrival_location, :delivery_company, :bid_id)
    end

    def order_status
      params.permit(:status)
    end
end
