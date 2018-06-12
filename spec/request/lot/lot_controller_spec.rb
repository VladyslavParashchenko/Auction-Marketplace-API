# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotsController, type: :request do
  before(:each) do
    @user_from_db = User.last
    @user = User.first
    @lot_arr = Lot.all
  end
  describe "GET lots#index" do
    subject do
      get "/lots", params: {page: 1, per: 10}, headers: @user.create_new_auth_token
    end
    it "should return list of lot" do
      subject
      data = json_parse(response.body)
      expect(data.length).to eq(10)
    end
  end
  describe "GET lots#my_lot" do
    context "select only lots that user create for sale" do
      subject do
        get "/lots/my", params: { filter: :all, page: 1, per: 10 }, headers: @user.create_new_auth_token
      end
      it "should return list of lot" do
        subject
        data = json_parse(response.body)
        expect(data.empty?).to be_falsey
      end
    end
    context "select only lots that user create for sale" do
      subject do
        get "/lots/my", params: {filter: :created, page: 1, per: 10}, headers: @user.create_new_auth_token
      end
      it "should return list of lot" do
        subject
        data = json_parse(response.body)
        data.each do |lot|
          expect(lot["user"]["id"]).to eq(@user.id)
        end
      end
    end
    context "select only lots that user won/try to win" do
      subject do
        get "/lots/my", params: {filter: :participation, page: 1, per: 10}, headers: @user.create_new_auth_token
        # request.headers.merge! @user.create_new_auth_token
      end
      it "should return list of lot" do
        subject
        data = json_parse(response.body)
        data.each do |lot|
          expect(Bid.where(lot_id: lot["user"]["id"]).user_id).to eq(@user.id)
        end
      end
    end
  end
  describe "POST lots#create" do
    describe "try create new lot with image" do
      let(:lot) do
        FactoryBot::attributes_for(:lot)
      end
      subject do
        post "/lots", params: lot, headers: @user.create_new_auth_token
      end
      it "should create new lot" do
        expect {subject}.to change {Lot.count}.by(1)
      end
    end
  end
  describe "Delete lots#destroy" do
    context "autorization user" do
      describe "delete user lot" do
        subject do
          delete "/lots/#{@lot_arr.first.id}", headers: @user.create_new_auth_token
        end
        it "should delete lot" do
          expect {subject}.to change {Lot.count}.by(-1)
        end
      end
      describe "delete lot of another user" do
        subject do
          lot = FactoryBot.create(:lot, user: @user_from_db)
          delete "/lots/#{lot.id}", headers: @user.create_new_auth_token
        end
        it "should return error" do
          subject
          data = json_parse(response.body)
          expect(data["errors"]["error"] == "You do not have rights to this action").to be_truthy
        end
      end
    end
    context "Unauthorized  user" do
      describe "delete user lot" do
        subject do
          delete "/lots/#{@lot_arr.first.id}"
        end
        it "should delete lot" do
          subject
          data = json_parse(response.body)
          expect(data["errors"].include? "You need to sign in or sign up before continuing.").to be_truthy
        end
      end
    end

  end
  describe "Update lots#update" do
    let(:new_title) do
      "Лот #1"
    end
    describe "update my lot" do
      subject do
        put "/lots/#{@user.lots.first.id}", params: {:title => new_title}, headers: @user.create_new_auth_token
      end
      it "should change title of lot" do
        subject
        data = json_parse(response.body)
        expect(data["resource"]["title"] == new_title).to be_truthy
      end
    end
    describe "update not my lot" do
      subject do
        lot = FactoryBot.create(:lot, user: @user_from_db)
        put "/lots/#{lot.id}", params: {:title => new_title}, headers: @user.create_new_auth_token
      end
      it "should return error message" do
        subject
        data = json_parse(response.body)
        expect(data["errors"]["error"] == "You do not have rights to this action").to be_truthy
      end
    end
    describe "update lot without user" do
      subject do
        lot = FactoryBot.create(:lot, user: @user_from_db)
        put "/lots/#{lot.id}", params: {:title => new_title}
      end
      it "should return error message" do
        subject
        data = json_parse(response.body)
        expect(data["errors"].include? "You need to sign in or sign up before continuing.").to be_truthy
      end
    end
    describe "update lot with invalid data" do
      subject do
        lot = FactoryBot.create(:lot, user: @user_from_db)
        put "/lots/#{lot.id}", params: {:title => new_title, current_price: -2000}, headers: @user.create_new_auth_token
      end
      it "should return validate error" do
        subject
        data = json_parse(response.body)
        expect(data["errors"].empty?).to be_falsey
      end
    end
  end
end
