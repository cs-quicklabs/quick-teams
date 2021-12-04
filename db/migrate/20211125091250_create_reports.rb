class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.string :title
      t.references  :reportable, polymorphic: true, null: false
       t.boolean :submitted, default: false
      t.timestamps
    end
  end
end
