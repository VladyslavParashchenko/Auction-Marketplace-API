require "rails_helper"

RSpec.describe LotWinnerMailer, type: :mailer do
  before(:each) do
    @user = create(:client)
    @lot = create(:lot, user: @user)
    10.times {create(:bid, lot: @lot, user: create(:client))}
  end
  let(:mail) {LotWinnerMailer.send_mail_to_lot_winner(@lot)}
  describe "Notify to winner" do
    it "should send email to true user" do
      expect(mail.to.first).to eq(@lot.bids.order("proposed_price desc").first.user.email)
    end
    it "should send email with true subject" do
      expect(mail.subject).to eq("You win lot #{@lot.title}")
    end
  end
end
