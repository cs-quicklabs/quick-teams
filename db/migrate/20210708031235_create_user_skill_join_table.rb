class CreateUserSkillJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :skills
  end
end
