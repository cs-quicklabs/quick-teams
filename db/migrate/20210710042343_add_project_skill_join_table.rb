class AddProjectSkillJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :projects, :skills
  end
end
