class CreatePolls < ActiveRecord::Migration[6.0]
  def change
    create_table :polls do |t|
      t.string :custom_id, null: false
      t.string :title, null: false
      t.text   :description, null: true
      t.references :user, foreign_key: true, index: true
      t.string :time_zone, null: true
      t.datetime :published_at, null: true
      t.datetime :started_at, null: true
      t.datetime :closed_at, null: true
      t.datetime :archived_at, null: true
      t.datetime :deleted_at, null: true
      t.index [:custom_id], unique: true, name: :ak_polls_custom_id

      t.timestamps
    end
  end
end
