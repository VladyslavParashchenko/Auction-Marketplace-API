# frozen_string_literal: true

require "rails_helper"
RSpec.describe LotsController, type: :request do
  before(:each) do
    @users = create_list(:client, 5)
    @users.each {|user| list = create_list(:lot, 5, user: user)}
    @user_from_db = User.last
    @user = User.first
    @lot_arr = Lot.all
    @lot_arr.each do |lot|
      lot.update_column(:status, :in_process)
      create_list(:bid, 10, user: @user_from_db, lot: lot)
      create_list(:bid, 10, user: @user, lot: lot)
    end
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
  describe "GET Lot#show" do
    describe "show not closed lot without order" do
      subject do
        get "/lots/#{@lot_arr.last.id}/", headers: @user.create_new_auth_token
      end
      it "should return list of bid" do
        subject
        data = json_parse(response.body)
        expect(data["bids"].count == @lot_arr.last.bids.count).to be_truthy
      end
    end
    describe "show closed lot with order" do
      before(:each) do
        @lot_for_order = @lot_arr.order("id").last
        @lot_for_order.update_column(:status, :closed)
        @order = create(:order, bid: @lot_for_order.find_winner_bid)
      end
      subject do
        get "/lots/#{@lot_for_order.id}/", headers: @user.create_new_auth_token
      end
      it "should return list of bid" do
        subject
        data = json_parse(response.body)
        expect(data["lot_order"]["id"]).to eq(@order.id)
      end
    end

  end

  describe "GET lots#my_lot" do
    context "select only lots that user create for sale" do
      subject do
        get "/lots/my", params: {filter: :all, page: 1, per: 10}, headers: @user.create_new_auth_token
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
      end
      it "should return list of lot" do
        subject
        data = json_parse(response.body)
        data.each do |lot|
          is_user_lot = false
          lot["bids"].each do |bid|
            if bid["user"] == "You"
              is_user_lot = true
            end
          end
          expect(is_user_lot).to be_truthy
        end
      end
    end
  end
  describe "POST lots#create" do
    let(:lot) do
      FactoryBot::attributes_for(:lot)
    end
    describe "try create new lot with image" do
      subject do
        post "/lots", params: lot, headers: @user.create_new_auth_token
      end
      it "should create new lot" do
        expect {subject}.to change {Lot.count}.by(1)
      end
    end
    include_examples "create operation without an authenticated user", "/lots/"
  end
  describe "Delete lots#destroy" do
    context "autorization user" do
      describe "delete user lot" do
        subject do
          delete "/lots/#{@user.lots.first.id}", headers: @user.create_new_auth_token
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
        expect(data["title"] == new_title).to be_truthy
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
