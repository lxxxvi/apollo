class CreateTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :tokens do |t|
      t.string :value, null: false
      t.references :poll, foreign_key: true, null: false
      t.references :nominee, foreign_key: true, null: true

      t.timestamps
    end
  end
end