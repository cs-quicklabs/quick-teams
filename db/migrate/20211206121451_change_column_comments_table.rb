class ChangeColumnCommentsTable < ActiveRecord::Migration[7.0]
  def self.up
    rename_column :comments, :goal_id, :commentable_id
    add_column :comments, :commentable_type, :string
  end
end
