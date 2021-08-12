class CreateNuggets < ActiveRecord::Migration[6.1]
  def change
    create_table :nuggets do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.boolean :published, default: false
      t.datetime :published_on
      t.timestamps
    end
  end
end
