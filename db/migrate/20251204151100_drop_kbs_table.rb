class DropKbsTable < ActiveRecord::Migration[8.1]
  def up
    drop_table :kbs, if_exists: true
  end

  def down
    create_table :kbs do |t|
      t.string :document
      t.string :link
      t.text :comments
      t.bigint :user_id, null: false
      t.bigint :discipline_id
      t.bigint :job_id
      t.bigint :account_id, null: false
      t.timestamps
    end

    add_index :kbs, :account_id
    add_foreign_key :kbs, :accounts
    add_foreign_key :kbs, :users
  end
end
