class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string     :key,   null: false
      t.string     :state, null: false, default: 'new'
      t.references :user,  null: false, index: true

      t.timestamps
    end
  end
end
