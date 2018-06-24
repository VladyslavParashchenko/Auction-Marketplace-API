# frozen_string_literal: true

require "api/users/passwords_controller"
class Users::PasswordsController < DeviseTokenAuth::PasswordsController
  include PasswordsDocs
end
