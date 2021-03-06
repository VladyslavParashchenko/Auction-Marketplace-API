# frozen_string_literal: true

class CreateLots < ActiveRecord::Migration[5.2]
  def change
    create_table :lots do |t|
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
