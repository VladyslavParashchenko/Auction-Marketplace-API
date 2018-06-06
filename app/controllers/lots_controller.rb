# frozen_string_literal: true


class LotsController < ApplicationController
  def index
    lots = Lot.all
    render json: lots
  end

  def my_lots
    lots = Lot.where(user_id: current_user.id)
    render json: lots
  end

  def create
    lot = current_user.lots.new(lot_params)
    if lot.save
      answer = { :message => "lot was created", "id" => lot.id }
      render json: answer
    else
      lot
      answer = { :message => "error", "id" => lot.id }
      render json: answer
    end
  end

  def show
    lot = Lot.find(params[:id])
    if (lot.nil?)
      render json: { message: "Lot not found" }, status: 404
    else
      render json: lot
    end
  end

  def destroy
    lot = Lot.find(params[:id])
    if lot.user_id == current_user.id
      lot.destroy
      render json: { message: "Lot was destroyed" }
    else
      render json: { message: "You do not have rights to this action" }, status: 403
    end
  end

  def update
    lot = Lot.find(params[:id])
    if lot.user_id == current_user.id
      lot.update(lot_params)
      render json: lot
    else
      render json: { message: "You do not have rights to this action" }, status: 403
    end
  end

  private

    def lot_params
      params.permit(:id, :title, :current_price, :estimated_price,
                    :lot_start_time, :lot_end_time, :status, :lot_image, :description)
    end
end
