# frozen_string_literal: true

require "api/users/sessions_controller"
class Users::SessionsController < DeviseTokenAuth::SessionsController
  include SessionsDocs
end
