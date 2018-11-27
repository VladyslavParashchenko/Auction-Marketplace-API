# frozen_string_literal: true

module PasswordsDocs
  extend ActiveSupport::Concern

  included do
    swagger_controller :user_session, "User password management"
    include Swagger::Docs::Methods

    swagger_api :create do
        summary "Reset password"
        param :query, :email, :string, :required, "Email for reset password"
        param :query, :redirect_url, :string, :required, "Url to page for set new password"
        response :not_found
        response :ok, "Success"
      end
    swagger_api :update do
      summary "Set new password"
      param :query, :password, :string, :required, "new password"
      param :query, :password_confirmation, :string, :required, "new password confirmation"
      response :not_found
      response :ok, "Success"
    end
  end
end
