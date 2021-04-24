class AddTypeToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :type, :integer, null: false, default: 0
  end
end
