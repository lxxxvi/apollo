class CreateTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :tokens do |t|
      t.string :value, null: false
      t.references :poll, foreign_key: true, null: false
      t.references :nominee, foreign_key: true, null: true
      t.datetime :first_visited_at, null: true

      t.index [:poll_id, :value], unique: true, name: :ak_tokens_poll_id_value

      t.timestamps
    end
  end
end
