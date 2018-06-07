# frozen_string_literal: true


class LotsController < ApplicationController
  COUNT_LOT_ON_PAGE = 10
  def index
    lots = Lot.where(status: :in_process).page(page).per(COUNT_LOT_ON_PAGE)
    render json: lots, c_user_id: current_user.id
  end

  def my_lots
    lots = Lot.where(user_id: current_user.id, status: :in_process).page(params[:page]).per(COUNT_LOT_ON_PAGE)
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
    lot = Lot.find_by_id(params[:id])
    if (lot.nil?)
      render json: { message: "Lot not found" }, status: 404
    else
      render json: lot
    end
  end

  def destroy
    lot = current_user.lots.find_by_id(params[:id])
    unless lot.nil?
      lot.destroy
      render json: { message: "Lot was destroyed" }
    else
      render json: { message: "You do not have rights to this action" }, status: 403
    end
  end

  def update
    lot = current_user.lots.find_by_id(params[:id])
    unless lot.nil?
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
    def page
      if params[:page].nil?
        1
      else
        params[:page]
      end
    end
end
