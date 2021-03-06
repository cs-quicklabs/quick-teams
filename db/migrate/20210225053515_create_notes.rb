class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.text :body
      t.references :notable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
