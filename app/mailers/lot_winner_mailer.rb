class LotWinnerMailer < ApplicationMailer
  def send_mail_to_lot_winner(lot)
    @user = lot.find_winner
    @lot = lot
    mail(to: @user.email, subject: "You win lot #{lot.title}")
  end
end
