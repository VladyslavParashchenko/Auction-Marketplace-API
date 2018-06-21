# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderController, type: :request do
  before(:each) do
    @lot = create(:lot)
    @bid = create(:bid, lot: @lot)
    @lot.update(status: :closed)
  end
  describe "POST order#create" do
    describe "try create new order for lot" do
      let(:order) {attributes_for(:order, bid: @bid)}
      subject do
        post "/lots/#{@lot.id}/order/", params: order, headers: @lot.user.create_new_auth_token
      end
      it "should return order for bid" do
        subject
        data = json_parse(response.body)
        expect(data["bid_id"]).to eq(@bid.id)
      end
    end
  end
  describe "PUT order#update" do
    before(:each) do
      @order = create(:order, bid: @bid)
    end
    subject do
      put "/lots/#{@lot.id}/order/#{@order.id}", params: order_status_attr, headers: @lot.user.create_new_auth_token
    end
    describe "try change status to sent" do
      let(:order_status_attr) {{status: "sent"}}
      it "should change status" do
        expect{ subject }.to change{Order.find(@order.id).status}.from("pending").to("sent")
      end
    end
    describe "try change status to sent" do
      let(:order_status_attr) {{status: "delivered"}}
      it "should change status" do
        expect{ subject }.to change{Order.find(@order.id).status}.from("pending").to("delivered")
      end
    end
  end

end
