# frozen_string_literal: true

module RegistrationsDocs
  extend ActiveSupport::Concern

  included do
    swagger_controller :user_registration, "User registration"
    include Swagger::Docs::Methods
    def self.add_common_params(api)
      api.param :form, :first_name, :string, :required, "User first_name"
      api.param :form, :last_name, :string, :required, "User last_name"
      api.param :form, :email, :string, :required, "User email"
      api.param :form, :phone, :string, :required, "User phone"
      api.param :form, :password, :string, :required, "User phone"
      api.param :form, :password_confirmation, :string, :required, "User phone"
      api.param :form, :birthday, :date, :required, "User birthday"
    end

    swagger_api :create do |api|
      summary "Create new user"
      Users::RegistrationsController.add_common_params(api)
      response :bad_request
      response :ok, "Success"
    end
  end
end
