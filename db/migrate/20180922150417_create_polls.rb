class CreatePolls < ActiveRecord::Migration[5.2]
  def change
    create_table :polls do |t|
      t.string :custom_id, null: false
      t.string :title, null: false
      t.text   :description, null: true
      t.string :email, null: false

      t.timestamps
    end
  end
end
