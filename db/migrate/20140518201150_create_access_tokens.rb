class CreateAccessTokens < ActiveRecord::Migration
  def change
    create_table :access_tokens do |t|
      t.references :user
      t.string     :digest
      t.datetime   :expiry

      t.timestamps
    end
    add_index :access_tokens, :digest
  end
end
