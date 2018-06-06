class ChangeImageColumnType < ActiveRecord::Migration[5.2]
  def change
    add_column :lots, :lot_image, :json
  end
end
