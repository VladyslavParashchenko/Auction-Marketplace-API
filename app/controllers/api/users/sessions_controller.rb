# frozen_string_literal: true

module SessionsDocs
  extend ActiveSupport::Concern

  included do
    swagger_controller :user_session, "User session management"
    include Swagger::Docs::Methods
    def self.add_params_for_sign_in(api)
      api.param :form, :email, :string, :required, "User email"
      api.param :form, :password, :string, :required, "User password"
      end
    def self.add_params_for_sign_out(api)
      api.param :form, :email, :string, :required, "User email"
      api.param :form, :password, :string, :required, "User password"
    end

    swagger_api :create do |api|
        summary "Create new user session"
        Users::SessionsController.add_params_for_sign_in(api)
        response :bad_request
        response :ok, "Success"
      end
    swagger_api :destroy do |api|
      summary "Destroy user session"
      Users::SessionsController.add_params_for_sign_out(api)
      response :unauthorized
      response :ok, "Success"
    end
  end
end
