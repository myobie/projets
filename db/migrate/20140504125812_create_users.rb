class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest
      t.datetime :password_expiry

      t.timestamps
    end
    add_index :users, :email
  end
end
