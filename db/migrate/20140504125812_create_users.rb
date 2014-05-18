class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :email, null: false
      t.string   :name
      t.string   :password_digest
      t.datetime :password_expiry
      t.string   :access_token
      t.datetime :access_token_expiry

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
