class AddColumnForLot < ActiveRecord::Migration[5.2]
  def change
    add_column :lots, :title, :string
    add_column :lots, :image, :string
    add_column :lots, :description, :text
    add_column :lots, :status, :integer, default: 0
    add_column :lots, :current_price, :decimal, :precision => 8, :scale => 2
    add_column :lots, :estimated_price, :decimal, :precision => 8, :scale => 2
    add_column :lots, :lot_start_time, :datetime
    add_column :lots, :lot_end_time, :datetime
  end
end
