class CreateProjectClients < ActiveRecord::Migration[7.0]
  def change
    create_join_table :projects, :clients
  end
end
