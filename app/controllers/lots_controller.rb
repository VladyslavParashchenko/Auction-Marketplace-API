# frozen_string_literal: true

class LotsController < ApplicationController
  def index
    lots = Lot.where(status: :in_process)
    render_collection(lots)
  end

  def my_lots
    user = User.find(current_user.id)
    lots = Lot.filter_my_lot(params[:filter], user)
    render_collection(lots)
  end

  def create
    lot = current_user.lots.new(lot_params)
    lot.save
    render_item(lot)
  end

  def show
    lot = Lot.find(params[:id])
    render_item(lot)
  end

  def destroy
    lot = current_user.lots.find(params[:id])
    lot.destroy
    render_item(lot)
  end

  def update
    lot = current_user.lots.find(params[:id])
    lot.update(lot_params)
    render_item(lot)
  end

  private

    def lot_params
      params.permit(:id, :title, :current_price, :estimated_price,
                    :lot_start_time, :lot_end_time, :status, :image, :description)
    end
end
