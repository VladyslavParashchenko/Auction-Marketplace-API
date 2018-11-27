# frozen_string_literal: true

require "rails_helper"
require "spec_helper"
RSpec.describe "Passwords", type: :request do
  let!(:user) { create(:client) }

  describe "POST create" do
    subject do  post "/auth/password", params:  {email: user.email, redirect_url: "/"},
                                       headers: user.create_new_auth_token
    end

    it "should respond with success" do
      subject
      expect(response.successful?).to be_truthy
    end
  end

  describe "GET edit" do
    before(:each) do
      raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      @user = create(:client, reset_password_token: enc, reset_password_sent_at: Time.now.utc)
      @token = raw
    end
    subject do
      get "/auth/password/edit", params: {
        reset_password_token: @token,
        redirect_url:         "/"
      }, headers: @user.create_new_auth_token
    end

    it "should respond with redirect" do
      subject
      expect(response).to be_redirect
    end

    it "should change user's reset token" do
      subject
      expect(@user.reload.reset_password_token).to eq @token
    end
  end

  describe "PUT create" do
    subject do
      put "/auth/password", params: {
        current_passord:       "password",
        password:              "new_password",
        password_confirmation: "new_password"
      }, headers: user.create_new_auth_token
    end

    it "should respond with success" do
      subject
      json_response = json_parse(response.body)
      expect(json_response["message"]).to eq("Your password has been successfully updated.")
    end
  end
end
