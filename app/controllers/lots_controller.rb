# frozen_string_literal: true


class LotsController < ApplicationController
  COUNT_LOT_ON_PAGE = 10
  before_action :authenticate_user!

  def index
    lots = Lot.where(status: :in_process)
    render_collection(lots)
  end

  def my_lots
    user_id = User.find(current_user.id)
    lots = Lot.filter_my_lot(params[:filter], user_id)
    render_collection(lots)
  end

  def create
    lot = current_user.lots.new(lot_params)
    lot.save
    render_item(lot)
  end

  def show
    lot = Lot.find_by_id(params[:id])
    if (lot.nil?)
      render_error({ error: "Lot not found" }, 404)
    else
      render_item(lot)
    end
  end

  def destroy
    lot = current_user.lots.find_by_id(params[:id])
    unless lot.nil?
      lot.destroy
      render_item(lot)
    else
      render_error({ error: "You do not have rights to this action" }, 403)
    end
  end

  def update
    lot = current_user.lots.find_by_id(params[:id])
    unless lot.nil?
      lot.update(lot_params)
      render_item(lot)
    else
      render_error({ error: "You do not have rights to this action" }, 403)
    end
  end

  private

    def lot_params
      params.permit(:id, :title, :current_price, :estimated_price,
                    :lot_start_time, :lot_end_time, :status, :image, :description)
    end

    def render_collection(resources)
      unless resources.nil?
        render json: resources.page(params[:page]).per(params[:per])
      else
        render json: {}
      end
    end

    def render_item(item)
      render json: { resource: item, errors: item.errors }
    end
    def render_error(errors, status)
      render json: { errors: errors }, status: status
    end
end
