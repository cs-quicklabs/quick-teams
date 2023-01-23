class CreateMessageComments < ActiveRecord::Migration[7.0]
  def change
    create_table :message_comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :message, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
