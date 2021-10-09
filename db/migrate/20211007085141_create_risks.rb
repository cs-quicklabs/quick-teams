class CreateRisks < ActiveRecord::Migration[7.0]
  def change
    create_table :risks do |t|
      t.text :body
      t.boolean :status, null: false, :default => true
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.timestamps
    end
  end
end
