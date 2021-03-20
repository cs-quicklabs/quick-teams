class AddTrackableToEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :trackable_id, :integer
    add_column :events, :trackable_type, :string
  end
end
