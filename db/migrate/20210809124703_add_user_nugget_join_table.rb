class AddUserNuggetJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :nuggets do |t|
      t.boolean :read, default: false
    end
  end
end
