class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string     :original_filename, null: false
      t.integer    :size,              null: false
      t.string     :content_type,      null: false
      t.string     :key,               null: false
      t.references :attachable,        null: false, index: true, polymorphic: true
      t.references :user,              null: false, index: true
      t.references :upload,            null: false, index: true

      t.timestamps
    end
  end
end
