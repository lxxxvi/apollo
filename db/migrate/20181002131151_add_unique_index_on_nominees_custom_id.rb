class AddUniqueIndexOnNomineesCustomId < ActiveRecord::Migration[5.2]
  def change
    add_index :nominees, [:custom_id], unique: true, name: :ak_nominees_custom_id
  end
end
