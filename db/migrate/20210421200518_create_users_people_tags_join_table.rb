class CreateUsersPeopleTagsJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :people_tags
  end
end
