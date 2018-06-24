# frozen_string_literal: true

module BidDocs
  extend ActiveSupport::Concern

  included do
    swagger_controller :bids, "Bid management"
    def self.add_common_params(api)
      api.param :form, :proposed_price, :float, :required, "Proposed price"
    end

    swagger_api :create do |api|
      summary "Create new bid for lot"
      BidsController.add_common_params(api)
      ApplicationController.add_devise_auth_params(api)
      response :unauthorized
      response :bad_request
      response :ok, "Success"
    end
  end
end
