class AddBillableToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :billable, :boolean, default: true
  end
end
