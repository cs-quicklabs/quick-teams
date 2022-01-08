class CreateTemplatesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :templates do |t|
      t.text :title
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.timestamps
    end
  end
end
