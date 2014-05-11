class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text       :content,     null: false
      t.references :commentable, null: false, index: true, polymorphic: true
      t.references :user,        null: false, index: true

      t.timestamps
    end
  end
end
