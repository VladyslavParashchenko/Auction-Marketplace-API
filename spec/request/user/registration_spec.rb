# frozen_string_literal: true

require "rails_helper"
require "spec_helper"
RSpec.describe "Registration test", type: :request do
  let(:user) { attributes_for(:client) }
  describe "POST create new user" do
    subject { post "/auth", params: user }
    describe "try POST request register " do
      it "return success status" do
        subject
        expect(json_parse(response.body)["data"]["email"]).to eq(user[:email])
      end
    end
    describe "check insertion in the database" do
      it "should change count of users in DB" do
        expect { subject }.to change(User, :count).by 1
      end
    end
    describe "check email confirmation was sent" do
      it "true if email confirmation was sent" do
        expect { subject }.to change(Devise.mailer.deliveries, :count).by(1)
      end
    end
  end
end
