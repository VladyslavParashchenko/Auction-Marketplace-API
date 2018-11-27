# frozen_string_literal: true

module LotDocs
  extend ActiveSupport::Concern

  included do
    swagger_controller :lots, "Lot management"
    swagger_api :index do |api|
      summary "Select lot items"
      notes "All selected lot has status in_process"
      LotsController.add_pagination_params(api)
      ApplicationController.add_devise_auth_params(api)
      response :unauthorized
      response :ok, "Success"
    end

    swagger_api :my_lots do |api|
      summary "Select lot items by some filter"
      param :query, :filter, :string, :required, "Filter of my_lots"
      LotsController.add_pagination_params(api)
      ApplicationController.add_devise_auth_params(api)
      response :unauthorized
      response :ok, "Success"
    end

    swagger_api :show do |api|
      summary "Get lot"
      param :path, :id, :integer, :required, "Lot id"
      ApplicationController.add_devise_auth_params(api)
      response :unauthorized
      response :ok, "Success"
    end

    swagger_api :create do |api|
      summary "Create new lot"
      LotsController.add_common_params_for_create_lot(api)
      ApplicationController.add_devise_auth_params(api)
      response :unauthorized
      response :bad_request
      response :ok, "Success"
    end

    swagger_api :update do |api|
      summary "Update lot"
      param :path, :id, :integer, :required, "Lot id"
      LotsController.add_common_params_for_update_lot(api)
      ApplicationController.add_devise_auth_params(api)
      response :unauthorized
      response :bad_request
      response :ok, "Success"
    end

    swagger_api :destroy do |api|
      summary "Create new lot"
      param :path, :id, :integer, :required, "Lot id"
      ApplicationController.add_devise_auth_params(api)
      response :unauthorized
      response :ok, "Success"
    end

    def self.add_pagination_params(api)
      api.param :query, :page, :integer, :optional, "Page number"
      api.param :query, :per, :integer, :optional, "Count of items on page"
    end

    def self.add_common_params_for_create_lot(api)
      api.param :form, :title, :string, :required, "Lot title"
      api.param :form, :description, :string, :optional, "Lot description"
      api.param :form, :image, :string, :optional, "Lot image"
      api.param :form, :current_price, :float, :required, "Lot current_price"
      api.param :form, :estimated_price, :float, :required, "Lot estimated_price"
      api.param :form, :lot_start_time, :date, :required, "Lot start_time"
      api.param :form, :lot_end_time, :date, :required, "Lot end_time"
      end

    def self.add_common_params_for_update_lot(api)
      api.param :form, :title, :string, :optional, "Lot title"
      api.param :form, :description, :string, :optional, "Lot description"
      api.param :form, :image, :string, :optional, "Lot image"
      api.param :form, :current_price, :float, :optional, "Lot current_price"
      api.param :form, :estimated_price, :float, :optional, "Lot estimated_price"
      api.param :form, :lot_start_time, :date, :optional, "Lot start_time"
      api.param :form, :lot_end_time, :date, :optional, "Lot end_time"
    end
  end
end
