class AddColorToPeopleTag < ActiveRecord::Migration[6.1]
  def change
    add_column :people_tags, :color, :string, null: false, default: "gray"
  end
end
