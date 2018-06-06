require 'rails_helper'

RSpec.describe LotsController, type: :request do
  before(:each) do
    @user = create(:user, :password)
    @lot = FactoryBot::attributes_for(:lot, :valid_start_and_end_time)
    post "/lots", params: @lot, headers: @user.create_new_auth_token
  end
  describe "GET lots#index" do
    subject do
      get "/lots"
    end
    it "get list of lot" do
      subject
      data = json_parse(response.body)
      expect(data.length > 0).to be_truthy
    end
  end
  describe "GET lots#my_lot" do
    subject do
      get "/lots/my", headers: @user.create_new_auth_token
    end
    it "get list of user lots" do
      subject
      data = json_parse(response.body)
      expect(data.length > 0).to be_truthy
    end
  end

  describe "POST lots#create" do
    describe "try create new lot with image" do
      subject do
        post "/lots", params: @lot, headers: @user.create_new_auth_token
      end
      it "create new lot" do
        message = json_parse(response.body)
        expect(message["message"] == "lot was created").to be_truthy
      end
    end
  end
  describe "Delete lots#destroy" do
    subject do
      delete "/lots/#{@lot[:id]}", headers: @user.create_new_auth_token
    end
    it "delete lot" do
      subject
      data = json_parse(response.body)
      expect(data["message"] == "Lot was destroyed").to be_truthy
    end
  end
  describe "Update lots#update" do
    subject do
      put "/lots/#{@lot[:id]}", params: @lot, headers: @user.create_new_auth_token
    end
    it "change title of lot" do
      @lot[:title] = "Лот #1"
      subject
      data = json_parse(response.body)
      expect(data["title"] == @lot[:title]).to be_truthy
    end
  end
end
