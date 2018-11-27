class AddPropertiesToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :arrival_location, :string
    add_column :orders, :arrival_type, :string
  end
end
