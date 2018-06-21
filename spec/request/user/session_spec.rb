# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Session test", type: :request do
  let(:user) { create(:client, confirmed_at: Time.now) }
  describe "sign in" do
    let(:user) { create(:client) }
    subject { post "/auth/sign_in", params: { email: user.email, password: user.password } }
    context "try login with valid data" do
      it "we sign in into the user" do
        subject
        expect(response.status).to eq(200)
        expect(controller.current_user.id).to eq(user.id)
        expect(response.has_header?("access-token")).to eq(true)
      end
    end
    context "try login with not valid data" do
      subject { post "/auth/sign_in", params: { email: Faker::Internet.email, password: "1224235225" } }
      it "return unsuccess status" do
        subject
        expect(response.status).to eq(401)
      end
    end
  end
  describe "sign out" do
    subject { delete "/auth/sign_out", headers: user.create_new_auth_token }
    it "return unsuccess status" do
      subject
      expect(response.status).to eq(200)
      expect(response.has_header?("access-token")).to eq(false)
      expect(json_parse(response.body)["success"]).to eq(true)
    end
  end
end
