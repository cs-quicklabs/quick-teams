class RenameTypeToStatus < ActiveRecord::Migration[6.1]
  def change
    rename_column :comments, :type, :status
  end
end
