class AddBillableResourcesToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :billable_resources, :decimal, precision: 4, scale: 2
  end
end
