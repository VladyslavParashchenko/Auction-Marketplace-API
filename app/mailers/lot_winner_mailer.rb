class LotWinnerMailer < ApplicationMailer
  # layout "winner"
  def send_mail_to_lot_winner(lot)
    @user = lot.bids.order("proposed_price desc").first.user
    @lot = lot
    mail(to: @user.email, subject: "You win lot #{lot.title}")
  end
end
