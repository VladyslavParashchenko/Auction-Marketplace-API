# frozen_string_literal: true

module OrderDocs
  extend ActiveSupport::Concern

  included do
    swagger_controller :order, "Order management"
    include Swagger::Docs::Methods
    def self.add_common_params(api)
      api.param :form, :arrival_type, :string, :required, "Order arrival type"
      api.param :form, :arrival_location, :string, :required, "Order arrival location"
      api.param :form, :delivery_company, :string, :optional, "Order delivery company"
    end

    swagger_api :create do |api|
      summary "Create new order"
      OrderController.add_common_params(api)
      response :bad_request
      response :unauthorized
      response :ok, "Success"
    end

    swagger_api :update do |api|
      summary "Update order status"
      param :query, :status, :string, :required, "New order status"
      response :unauthorized
      response :bad_request
      response :ok, "Success"
    end
  end
end
