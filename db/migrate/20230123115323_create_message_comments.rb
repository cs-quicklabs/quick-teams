class CreateMessageComments < ActiveRecord::Migration[7.0]
  def change
    create_table :message_comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :message, null: false, foreign_key: true
      t.timestamps
    end
  end
end
