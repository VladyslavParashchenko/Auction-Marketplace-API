# frozen_string_literal: true

class LotPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def initialize(user, lot)
    @user = user
    @lot = lot
  end

  def show?
    if @lot.in_process?
      true
    else
      if @lot.pending?
        @user.id == @lot.user.id
      elsif @lot.closed?
        @user.id == @lot.user_id || @user.id == @lot.get_winner_bid.user_id
      end
    end
  end
end
