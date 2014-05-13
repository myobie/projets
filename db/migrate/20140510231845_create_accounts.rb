class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string  :name,      null: false
      t.integer :admin_ids, array: true, default: []
      t.integer :owner_id,  null: false

      t.timestamps
    end
    add_index :accounts, :admin_ids, using: 'gin'
    add_index :accounts, :owner_id
  end
end
