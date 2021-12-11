class BackfillComments < ActiveRecord::Migration[7.0]
  def change
    Comment.update_all(commentable_type: "Goal")
  end
end
