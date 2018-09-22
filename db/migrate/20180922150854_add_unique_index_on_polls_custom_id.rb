class AddUniqueIndexOnPollsCustomId < ActiveRecord::Migration[5.2]
  def change
    add_index :polls, [:custom_id], unique: true, name: :ak_polls_custom_id
  end
end
