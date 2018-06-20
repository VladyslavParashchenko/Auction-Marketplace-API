require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  before(:each) do
    @user = create(:client)
    @lot = create(:lot, user: @user)
    10.times { create(:bid, lot: @lot) }
  end
  describe "Notify to seller, lot was purchased" do
    let(:mail) { NotificationMailer.send_seller_lot_purchased(@lot.find_winner_bid) }

    it "should send email to lot owner" do
      expect(mail.to.first).to eq(@lot.user.email)
    end
    it "should send email with correct subject" do
      expect(mail.subject).to eq("Your lot #{@lot.title} was purchased")
    end
  end
  describe "Order notify" do
    before(:each) do
      @lot.update_column(:status, :closed)
      @order = create(:order, bid: @lot.find_winner_bid)
    end
    context "order was created" do
      let(:mail) { NotificationMailer.send_seller_order_create(@order) }
      it "should send email to lot owner" do
        expect(mail.to.first).to eq(@lot.user.email)
      end
      it "should send email with correct subject" do
        expect(mail.subject).to eq("Customer create order for your lot #{@lot.title}")
      end
    end
    context "lot was sent to customer" do
      let(:mail) { NotificationMailer.send_customer_lot_sent(@order) }
      it "should send email to lot owner" do
        expect(mail.to.first).to eq(@lot.find_winner.email)
      end
      it "should send email with correct subject" do
        expect(mail.subject).to eq("Lot #{@lot.title} was sent to you")
      end
    end
  end
end

