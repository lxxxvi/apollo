class CreatePolls < ActiveRecord::Migration[5.2]
  def change
    create_table :polls do |t|
      t.string :custom_id, null: false
      t.string :title, null: false
      t.text   :description, null: true
      t.references :user, foreign_key: true, index: true
      t.datetime :published_at, null: true
      t.datetime :started_at, null: true
      t.datetime :closed_at, null: true
      t.index [:custom_id], unique: true, name: :ak_polls_custom_id

      t.timestamps
    end
  end
end
