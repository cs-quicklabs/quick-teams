class TemplatesAssignees < ActiveRecord::Migration[7.0]
  def change
    create_table "templates_assignees", force: :cascade do |t|
      t.references :template, null: false, foreign_key: true
      t.references :assignable, null: false, polymorphic: true
      t.timestamps
    end
  end
end
