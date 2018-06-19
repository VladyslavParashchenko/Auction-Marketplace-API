# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      user = User.find(cookies.signed[:user_id])
      return user if user
      reject_unauthorized_connection
    end
  end
end
