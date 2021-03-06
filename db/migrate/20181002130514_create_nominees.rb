class CreateNominees < ActiveRecord::Migration[6.0]
  def change
    create_table :nominees do |t|
      t.string :custom_id, null: false
      t.references :poll, null: false
      t.string :name, null: false
      t.text :description, null: true
      t.string :image_placeholder, null: false
      t.index [:custom_id], unique: true, name: :ak_nominees_custom_id

      t.timestamps
    end
  end
end
