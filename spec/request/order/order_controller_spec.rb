# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderController, type: :request do
  before(:each) do
    @lot = create(:lot, :lot_with_bid)
    @bid = @lot.find_winner_bid
    @lot.update(status: :closed)
  end
  describe "POST order#create" do
    describe "try create new order for lot" do
      let(:order) { attributes_for(:order).merge(bid_id: @bid.id) }
      context "order create user that win lot" do
        subject do
          post "/lots/#{@lot.id}/order/", params: order, headers: @bid.user.create_new_auth_token
        end
        it "should return order for bid" do
          subject
          data = json_parse(response.body)
          expect(data["bid_id"]).to eq(@bid.id)
        end
      end
      context "order create user that win lot" do
        subject do
          post "/lots/#{@lot.id}/order/", params: order, headers: create(:client).create_new_auth_token
        end
        include_examples "return permission error"
      end
    end
  end
  describe "PUT order#update" do
    before(:each) do
      @order = create(:order, bid: @bid)
    end
    context "current user is the creator of the lot" do
      subject do
        put "/lots/#{@lot.id}/order/#{@order.id}", params: order_status_attr, headers: @lot.user.create_new_auth_token
      end
      describe "try change status to sent" do
        let(:order_status_attr) { { status: "sent" } }
        it "should change status" do
          expect { subject }.to change { Order.find(@order.id).status }.from("pending").to("sent")
        end
      end
    end
    context "current user is the random user" do
      subject do
        put "/lots/#{@lot.id}/order/#{@order.id}", params: order_status_attr, headers: create(:client).create_new_auth_token
      end
      describe "try change status to sent" do
        let(:order_status_attr) { { status: "sent" } }
        include_examples "return permission error"
      end
    end
    context "current user is the customer of the lot" do
      describe "try change status to delivered" do
        before(:each) { @order.update_column(:status, :sent) }
        subject do
          put "/lots/#{@lot.id}/order/#{@order.id}", params: order_status_attr, headers: @order.bid.user.create_new_auth_token
        end
        let(:order_status_attr) { { status: "delivered" } }
        it "should change status" do
          expect { subject }.to change { Order.find(@order.id).status }.from("sent").to("delivered")
        end
      end
    end
    context "current user is the creator of the lott" do
      describe "try change status to delivered" do
        before(:each) { @order.update_column(:status, :sent) }
        subject do
          put "/lots/#{@lot.id}/order/#{@order.id}", params: order_status_attr, headers: @lot.user.create_new_auth_token
        end
        let(:order_status_attr) { { status: "delivered" } }
        include_examples "return permission error"
      end
    end

  end
end
