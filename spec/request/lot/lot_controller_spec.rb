# frozen_string_literal: true

require "rails_helper"
RSpec.describe LotsController, type: :request do
  before(:each) do
    @users = create_list(:client, 2)
    @users.each {|user| create_list(:lot, 5, :lot_with_bid, user: user) }
    @user = @users.first
    @second_user = @users.last
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
  describe "GET Lot#show" do
    describe "show not closed lot without order" do
      let(:lot_for_test) { create(:lot) }
      let(:random_user) { create(:client) }
      subject do
        get "/lots/#{lot_for_test.id}/", headers: random_user.create_new_auth_token
      end
      include_examples "return permission error"
    end
    describe "show foreign lot with pending status" do
      subject do
        get "/lots/#{@lot_arr.last.id}/", headers: @user.create_new_auth_token
      end
      it "should return list of bid" do
        subject
        data = json_parse(response.body)
        expect(data["bids"].count).to eq(@lot_arr.last.bids.count)
      end
    end
    describe "show closed lot with order" do
      before(:each) do
        @lot_for_order = @lot_arr.order("id").last
        @lot_for_order.update(status: :closed)
        @order = create(:order, bid: @lot_for_order.find_winner_bid)
      end
      subject do
        get "/lots/#{@lot_for_order.id}/", headers: @lot_for_order.get_winner_bid.user.create_new_auth_token
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
          expect(lot["is_user_lot"]).to eq(true)
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
            is_user_lot = true if bid["user"] == "You"
          end
          expect(is_user_lot).to be_truthy
        end
      end
    end
  end
  describe "POST lots#create" do
    let(:lot) do
      attributes_for(:lot, :lot_image)
    end
    let(:headers) do
      @user.create_new_auth_token.merge(content_type: "multipart/form-data;")
    end
    describe "try create new lot with image" do
      subject do
        post "/lots", params: lot, headers: headers
      end
      it "should change a count of lot" do
        expect { subject }.to change { Lot.count }.by(1)
        expect(json_parse(response.body)["image"]["url"]).to be
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
          expect { subject }.to change { Lot.count }.by(-1)
        end
      end
      describe "delete lot of another user" do
        subject do
          lot = create(:lot, user: @second_user)
          delete "/lots/#{lot.id}", headers: @user.create_new_auth_token
        end
        include_examples "return permission error"
      end
    end
    context "Unauthorized  user" do
      describe "delete user lot" do
        subject do
          delete "/lots/#{@lot_arr.first.id}"
        end
        include_examples "session error"
      end
    end
  end
  describe "Update lots#update" do
    let(:new_title) { "Лот #1" }
    describe "update my lot" do
      subject do
        put "/lots/#{@user.lots.first.id}", params: {title: new_title}, headers: @user.create_new_auth_token
      end
      it "should change title of lot" do
        subject
        data = json_parse(response.body)
        expect(data["title"] == new_title).to be_truthy
      end
    end
    describe "update not my lot" do
      subject do
        lot = create(:lot, user: @second_user)
        put "/lots/#{lot.id}", params: {title: new_title}, headers: @user.create_new_auth_token
      end
      include_examples "return permission error"
    end
    describe "update lot without user" do
      subject do
        lot = create(:lot, user: @second_user)
        put "/lots/#{lot.id}", params: {title: new_title}
      end
      include_examples "session error"
    end
    describe "update lot with invalid data" do
      subject do
        lot = create(:lot, user: @second_user)
        put "/lots/#{lot.id}", params: {title: new_title, current_price: -2000}, headers: @user.create_new_auth_token
      end
      it "should return validate error" do
        subject
        data = json_parse(response.body)
        expect(data["errors"].empty?).to be_falsey
      end
    end
  end
end
