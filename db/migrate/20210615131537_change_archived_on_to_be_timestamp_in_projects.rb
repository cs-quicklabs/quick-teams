class ChangeArchivedOnToBeTimestampInProjects < ActiveRecord::Migration[6.1]
  def change
    change_column :projects, :archived_on, :timestamp
  end
end
