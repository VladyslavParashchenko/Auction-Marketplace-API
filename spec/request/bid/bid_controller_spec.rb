# frozen_string_literal: true

require "rails_helper"

RSpec.describe BidsController, type: :request do
  before(:each) do
    @users = create_list(:client, 5)
    @user = @users.first
    @lot = create(:lot, user: @user)
    @lot_id = @lot.id
  end
  describe "POST bids#create" do
    describe "try create new bid with a lower price" do
      subject do
        post "/lots/#{@lot.id}/bids/", params: bid, headers: @user.create_new_auth_token
      end
      let(:bid) { attributes_for(:bid, lot: @lot, proposed_price: @lot.current_price - 100) }
      it "should return error message" do
        subject
        data = json_parse(response.body)
        expect(data["errors"].empty?).to be_falsey
      end
    end
    describe "try create new bid with a higher price" do
      subject do
        post "/lots/#{@lot.id}/bids/", params: bid, headers: @user.create_new_auth_token
      end
      let(:bid) { attributes_for(:bid, lot: @lot, proposed_price: (@lot.current_price + 100)) }
      it "should create new lot" do
        expect { subject }.to change { Bid.count }.by(1)
      end
    end
    describe "try create new bid with a higher price and check that current price changed" do
      subject do
        post "/lots/#{@lot.id}/bids/", params: bid, headers: @user.create_new_auth_token
      end
      let(:bid) { attributes_for(:bid, lot: @lot, proposed_price: (@lot.current_price + 100)) }
      it "should lot current_price_change" do
        expect { subject }.to change { Lot.find(@lot.id).current_price }.from(@lot.current_price).to(bid[:proposed_price])
      end
    end
    include_examples "create operation without an authenticated user", "/lots/1/bids/"
  end

end
