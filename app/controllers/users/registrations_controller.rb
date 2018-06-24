# frozen_string_literal: true

require "api/users/registrations_controller"
class Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
  include RegistrationsDocs
end
