# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def initialize(user, order)
    @user = user
    @order = order
  end

  def create?
    @order.bid.user_id == @user.id
  end

  def update?
    if @order.pending?
      @user.id == @order.lot.user.id
    elsif @order.sent?
      @user.id == @order.bid.user.id
    end
  end
end
