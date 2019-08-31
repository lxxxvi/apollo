class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.datetime :email_verified_at, null: true
      t.string :authentication_token, null: false
      t.datetime :authentication_token_expires_at, null: false

      t.index [:email], unique: true, name: :ak_users_email

      t.timestamps
    end
  end
end
