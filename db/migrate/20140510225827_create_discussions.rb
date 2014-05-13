class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.string     :name,    null: false
      t.references :user,    null: false, index: true
      t.references :project, null: false, index: true

      t.timestamps
    end
  end
end
