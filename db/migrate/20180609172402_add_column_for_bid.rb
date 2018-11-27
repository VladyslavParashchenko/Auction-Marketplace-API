class AddColumnForBid < ActiveRecord::Migration[5.2]
  def change
    add_column :bids, :proposed_price, :decimal, precision: 8, scale: 2
  end
end
