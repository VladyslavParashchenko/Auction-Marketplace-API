class AddJidForLot < ActiveRecord::Migration[5.2]
  def change
    add_column :lots, :start_jid, :string
    add_column :lots, :end_jid, :string
  end
end
