class AddColumnCommentsKb < ActiveRecord::Migration[6.1]
  def change
    add_column :kbs, :comments, :string
  end
end
