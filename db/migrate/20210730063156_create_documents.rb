class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.string :filename
      t.string :link
      t.references :user, null: false, foreign_key: true
      t.string :comments
      t.references :documenter, polymorphic: true, null: false

      t.timestamps
    end
  end
end
