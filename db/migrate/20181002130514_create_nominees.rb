class CreateNominees < ActiveRecord::Migration[5.2]
  def change
    create_table :nominees do |t|
      t.string :custom_id, null: false
      t.references :poll, null: false
      t.string :name, null: false
      t.text :description, null: true

      t.timestamps
    end
  end
end
