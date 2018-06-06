class DeleteImageColumnFromLots < ActiveRecord::Migration[5.2]
  def change
    remove_column :lots, :image
  end
end
