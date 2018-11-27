# frozen_string_literal: true

require "rails_helper"
RSpec.describe "Сonfirmation", type: :request do
  before(:each) do
    @user = create(:client, confirmed_at: nil)
  end
  subject do
    get "/auth/confirmation", params: {
      config:             "default",
      confirmation_token: @user.confirmation_token,
      redirect_url:       "/"
    }
  end
  describe "GET /api/auth/confirmation" do
    it "should respond with success" do
      subject
      expect(response).to be_redirect
      expect(@user.reload.confirmed_at.nil?).to be_falsey
    end
  end
end
