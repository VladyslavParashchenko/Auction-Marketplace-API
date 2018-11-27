# frozen_string_literal: true

class ChangeOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :delivery_company, :string
    change_column :orders, :arrival_type, 'integer USING CAST(arrival_type AS integer)'
  end
end
