# frozen_string_literal: true

require "rails_helper"

RSpec.describe BidsController, type: :request do
  before(:each) do
    @user = User.first
    @lot = Lot.last
    @bid = FactoryBot.create(:bid, lot: @lot, user: @user)
  end
  describe "GET bid#show" do
    subject do
      get "/lots/#{@lot.id}/bids/#{@bid.id}", headers: @user.create_new_auth_token
    end
    it "should return list of lot" do
      subject
      data = json_parse(response.body)
      expect(data["id"].to_i == @bid.id).to be_truthy
    end
  end
  describe "GET Lot#show" do
    subject do
      get "/lots/#{@lot.id}/", headers: @user.create_new_auth_token
    end
    it "should return list of lot" do
      subject
      data = json_parse(response.body)
      expect(data["bids"].count == @lot.bids.count).to be_truthy
    end
  end

  describe "POST bids#create" do
    subject do
      post "/lots/#{@lot.id}/bids/", params: bid, headers: @user.create_new_auth_token
    end
    describe "try create new bid with a lower price" do
      let(:bid) do
        bid = FactoryBot::attributes_for(:bid)
        bid[:lot_id] = @lot.id
        bid[:proposed_price] = @bid.proposed_price - 100
        bid
      end
      it "should return error message" do
        subject
        data = json_parse(response.body)
        expect(data["errors"].empty?).to be_falsey
      end
    end
    describe "try create new bid with a higher price" do
      let(:bid) do
        bid = {}
        bid[:lot_id] = @lot.id
        bid[:proposed_price] = @bid.proposed_price + 100
        bid
      end
      it "should create new lot" do
        expect { subject }.to change { Bid.count }.by(1)
      end
    end
  end
end
