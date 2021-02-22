class CreateProjectTags < ActiveRecord::Migration[6.1]
  def change
    create_table :project_tags do |t|
      t.string :name, null: false
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
