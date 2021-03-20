class AddContextActionToEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :action_for_context, :string
  end
end
