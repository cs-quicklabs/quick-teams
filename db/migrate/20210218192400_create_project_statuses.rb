class CreateProjectStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :project_statuses do |t|
      t.string :name, null: false
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
