class CreateProjectsProjectTagsJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :projects, :project_tags
  end
end
