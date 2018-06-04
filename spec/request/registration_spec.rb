require "rails_helper"
require "json"
RSpec.describe "User account CRUD", :type => :request do
  let(:user) {
    {
        first_name:            "Ivan",
        last_name:             "Ivanov",
        email:                 "user451@gmail.com",
        password:              "pass1234",
        password_confirmation: "pass1234",
        phone:                 "1234567890",
        birthday:               50.years.ago,
        allow_password_change: true
    }
  }
  describe "CREATE - POST request" do
    subject {
      post "/auth", params: user
      response
    }
    describe "try POST request register " do
      it "return success status" do
        response_body = JSON.parse(subject.body)
        expect(response_body["status"] == "success").to be_truthy
      end
    end
    describe "check insertion in the database" do
      it "find user that we insert in DB" do
        expect{
          subject
        }.to change(User, :count).by 1
      end
      end
    describe "check email confirmation was sent" do
      it "true if email confirmation was sent" do
        expect { subject }.to change(Devise.mailer.deliveries, :count).by(1)
      end
    end
  end
  describe "DELETE - delete user" do
    subject {
      delete "/auth", params: {email: user[:email], password: user[:password] }, headers: @controller.current_user.create_new_auth_token
    }
    describe "try delete user " do
      it "return true if user deleted" do
        post "/auth", params: user
        subject
        response_body = JSON.parse(response.body)
        expect(response_body["status"] == "success").to be_truthy
      end
    end
  end
end

