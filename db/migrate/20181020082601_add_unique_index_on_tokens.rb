class AddUniqueIndexOnTokens < ActiveRecord::Migration[5.2]
  def change
    add_index :tokens, [:poll_id, :value], unique: true, name: 'ak_tokens_poll_id_value'
  end
end
