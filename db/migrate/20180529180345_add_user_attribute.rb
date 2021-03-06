# frozen_string_literal: true

class AddUserAttribute < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password, :string
    add_column :users, :email, :string
    add_column :users, :phone, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthday, :datetime
  end
end
