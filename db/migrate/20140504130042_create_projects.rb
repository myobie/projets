class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name,      null: false
      t.integer :user_ids, array: true, default: []
      t.integer :owner_id, null: false

      t.timestamps
    end
    add_index :projects, :user_ids, using: 'gin'
  end
end
