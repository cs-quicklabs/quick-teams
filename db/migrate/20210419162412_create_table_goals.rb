class CreateTableGoals < ActiveRecord::Migration[6.1]
  def change
    create_table :goals do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.references :goalable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
