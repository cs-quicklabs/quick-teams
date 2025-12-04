class DropNuggetsTables < ActiveRecord::Migration[8.1]
  def up
    drop_table :nuggets_users, if_exists: true
    drop_table :nuggets, if_exists: true
  end

  def down
    create_table :nuggets do |t|
      t.string :title
      t.bigint :user_id, null: false
      t.bigint :skill_id, null: false
      t.boolean :published, default: false
      t.timestamps
      t.bigint :account_id, null: false
    end

    add_index :nuggets, :account_id
    add_index :nuggets, :skill_id
    add_index :nuggets, :user_id
    add_foreign_key :nuggets, :accounts
    add_foreign_key :nuggets, :skills
    add_foreign_key :nuggets, :users

    create_table :nuggets_users do |t|
      t.bigint :user_id, null: false
      t.bigint :nugget_id, null: false
      t.boolean :read, default: false
      t.timestamps
    end
  end
end
