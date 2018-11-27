# frozen_string_literal: true

require "helpers/render_helper"

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Json_Helper
  include Pundit
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :permission_denied_answer
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied_answer

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone, :birthday, :password, :password_confirmation, :allow_password_change])
      devise_parameter_sanitizer.permit(:account_update, keys: [:password, :password_confirmation, :current_password])
    end

    def permission_denied_answer
      render_error({ error: "You do not have rights to this action" }, 400)
    end

    class << self
      Swagger::Docs::Generator.set_real_methods

      def add_devise_auth_params(api)
        api.param :header, "uid", :string, :required, "uid"
        api.param :header, "access-token", :string, :required, "access-token"
        api.param :header, "client", :string, :required, "client"
      end
      private
    end
end
