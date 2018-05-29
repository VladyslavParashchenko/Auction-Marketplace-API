class CreateBids < ActiveRecord::Migration[5.2]
  def change
    create_table :bids do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :lot, foreign_key: true
      t.timestamps
    end
  end

end
