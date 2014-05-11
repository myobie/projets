class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string     :name,     null: false
      t.references :account,  null: false, index: true
      t.integer    :member_ids,            array: true, default: []
      t.integer    :owner_id, null: false

      t.timestamps
    end
    add_index :projects, :member_ids, using: 'gin'
    add_index :projects, :owner_id
  end
end
