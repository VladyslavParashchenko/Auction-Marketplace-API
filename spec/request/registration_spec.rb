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
        birthday:             50.years.ago,
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
        subject
        user_from_db = User.where(email: user[:email])
        expect(user_from_db.empty?).to be_falsey
      end
      end
    describe "check email confirmation was sent" do
      it "true if email confirmation was sent" do
        expect { subject }.to change(Devise.mailer.deliveries, :count).by(1)
      end
    end
    end
  describe "UPDATE - change password" do
    let(:user_with_new_password) do
      user2 = user.clone
      user2[:password] = "password"
      user2[:password_confirmation] = "password"
      user2[:current_password] = user[:password]
      user2
    end
    describe "try change password " do
      it "return true if password changed" do
        post "/auth", params: user
        put "/auth", params: user_with_new_password, headers: @controller.current_user.create_new_auth_token
        response_body = JSON.parse(response.body)
        expect(response_body["status"] == "success").to be_truthy
      end
    end
  end
  describe "DELETE - delete user" do
    describe "try delete user " do
      it "return true if user deleted" do
        post "/auth", params: user
        delete "/auth", params: {email: user[:email], password: user[:password] }, headers: @controller.current_user.create_new_auth_token
        response_body = JSON.parse(response.body)
        expect(response_body["status"] == "success").to be_truthy
      end
    end
  end
end

