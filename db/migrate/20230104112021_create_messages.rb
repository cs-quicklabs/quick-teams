class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :title
      t.references :account, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.references :space, foreign_key: true, null: false
      t.timestamps
    end
  end
end
