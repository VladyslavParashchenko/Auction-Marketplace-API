require "rails_helper"

RSpec.describe "sign test", :type => :request do
  let(:user) {
    {
        first_name:            "Ivan",
        last_name:             "Ivanov",
        email:                 "user451@gmail.com",
        password:              "12345678",
        password_confirmation: "12345678",
        phone:                 "1234567890",
        birthday:              50.years.ago,
        confirmed_at: Time.now
    }
  }
  describe "sign in" do
    subject {
      post "/auth/sign_in", params: user
      response
    }
    before(:each) do
      User.create user
    end
    describe "try login with valid data" do
        it "we sign in into the user" do
          response = subject
          expect(controller.current_user.email).to eq(user[:email])
        end
      end
    describe "try login with not valid data" do
      subject {
        post "/auth/sign_in", params: { email: "244244@gmail.com", password: "1224235225" }
        response
      }
      it "return unsuccess status" do
        response = subject
        expect(response.successful?).to be_falsey
      end
    end
  end
  describe "sign out" do
    subject {
      delete "/auth/sign_out", params: user
      response
    }
    it "return unsuccess status" do
        post "/auth/sign_in", params: user
        response = subject
        expect(@controller.current_user).to be_nil
    end
  end
end
