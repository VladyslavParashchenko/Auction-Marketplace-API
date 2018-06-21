class NotificationMailer < ApplicationMailer
  def send_seller_lot_purchased(bid)
    @user = bid.lot.user
    @lot = bid.lot
    mail(to: @user.email, subject: "Your lot #{@lot.title} was purchased")
  end

  def send_seller_order_create(order)
    @bid = order.bid
    @user = @bid.lot.user
    @lot = @bid.lot
    @order = order
    mail(to: @user.email, subject: "Customer create order for your lot #{@lot.title}")
  end

  def send_customer_lot_sent(order)
    @bid = order.bid
    @lot = order.bid.lot
    @user = @bid.user
    mail(to: @bid.user.email, subject: "Lot #{@bid.lot.title} was sent to you")
  end
end