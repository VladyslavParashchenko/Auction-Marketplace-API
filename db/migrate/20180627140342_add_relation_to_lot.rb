class AddRelationToLot < ActiveRecord::Migration[5.2]
  def change
    add_column :lots, :winner_bid, :integer, index: true
    add_foreign_key :lots, :bids, column: :winner_bid
  end
end
