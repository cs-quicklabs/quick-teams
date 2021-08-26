class CreateKnowledgeBases < ActiveRecord::Migration[6.1]
  def change
    create_table :kbs do |t|
      t.string :document
      t.string :link
      t.references :user, null: false, foreign_key: true
      t.references :discipline, foreign_key: true
      t.references :job, foreign_key: true
      t.string :tag

      t.timestamps
    end
  end
end
