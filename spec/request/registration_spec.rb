require "rails_helper"

RSpec.describe "User account CRUD", :type => :request do
  let(:user) {
    {
        first_name:            "Ivan",
        last_name:             "Ivanov",
        email:                 "user451@gmail.com",
        password:              "12345678",
        password_confirmation: "12345678",
        phone:                 "1234567890",
        birthday:             50.years.ago,
        confirmed_at: Time.now
    }
  }
  describe "CREATE - POST request" do
    subject {
      post "/auth", params: user
      response
    }
    describe "try POST request register " do
      it "return success status" do
        expect(subject.successful?).to be_truthy
      end
    end
    describe "check insertion in the database" do
      it "find user that we insert in DB" do
        subject
        user_from_db = User.where(email: user[:email])
        expect(user_from_db.empty?).to be_falsey
      end
    end
    end
  describe "UPDATE - change password" do
  describe "try change password " do
    it "password was changed" do
      post "/auth", params: user
      user2 = user.clone
      user2[:password] = "password"
      user2[:password_confirmation] = "password"
      user2[:current_password] = user[:password]
      post "/auth", params: user2
      #TODO проверить что данные вставлены
    end
  end
  end
  end
