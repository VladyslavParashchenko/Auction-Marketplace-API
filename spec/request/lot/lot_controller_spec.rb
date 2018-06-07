# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotsController, type: :request do
  before(:each) do
    @user_from_db = User.last
    @user = User.first
    @lot_arr = []
    15.times {
      lot = FactoryBot.build(:lot, :valid_start_and_end_time)
      lot.user_id = @user.id
      if lot.save
        @lot_arr << lot
      end
    }
  end
  describe "GET lots#index" do
    subject do
      get "/lots", params: { page: 2 }, headers: @user.create_new_auth_token
    end
    it "should return list of lot" do
      subject
      data = json_parse(response.body)
      expect(data.length > 0).to be_truthy
    end
  end
  describe "GET lots#my_lot" do
    subject do
      get "/lots/my", headers: @user.create_new_auth_token
    end
    it "should return list of lot" do
      subject
      data = json_parse(response.body)
      expect(data.length > 0).to be_truthy
    end
  end

  describe "POST lots#create" do
    describe "try create new lot with image" do
      let(:lot) do
        FactoryBot::attributes_for(:lot, :valid_start_and_end_time)
      end
      subject do
        post "/lots", params: lot, headers: @user.create_new_auth_token
      end
      it "should create new lot" do
        subject
        message = json_parse(response.body)
        expect(message["message"] == "lot was created").to be_truthy
      end
    end
  end
  describe "Delete lots#destroy" do
    describe "delete user lot" do
      subject do
        delete "/lots/#{@lot_arr.first.id}", headers: @user.create_new_auth_token
      end
      it "should delete lot" do
        subject
        data = json_parse(response.body)
        expect(data["message"] == "Lot was destroyed").to be_truthy
      end
      end
    describe "delete lot of another user" do
     subject do
       lot = FactoryBot.build(:lot, :valid_start_and_end_time)
       lot.user_id = @user_from_db.id
       lot.save
       delete "/lots/#{lot.id}", headers: @user.create_new_auth_token
     end
     it "should return error" do
       subject
       data = json_parse(response.body)
       expect(data["message"] == "You do not have rights to this action").to be_truthy
     end
   end
  end
  describe "Update lots#update" do
    let(:new_title) do
      "Лот #1"
    end
    describe "update my lot" do
      subject do
        put "/lots/#{Lot.take.id}", params: {:title => new_title}, headers: @user.create_new_auth_token
      end
      it "should change title of lot" do
        subject
        data = json_parse(response.body)
        expect(data["title"] == new_title).to be_truthy
      end
    end
    describe "update not my lot" do
      subject do
        lot = FactoryBot.build(:lot, :valid_start_and_end_time)
        lot.user_id = @user_from_db.id
        lot.save
        put "/lots/#{lot.id}", params: {:title => new_title}, headers: @user.create_new_auth_token
      end
      it "should return error message" do
        subject
        data = json_parse(response.body)
        expect(data["message"] == "You do not have rights to this action").to be_truthy
      end
    end
  end
end
