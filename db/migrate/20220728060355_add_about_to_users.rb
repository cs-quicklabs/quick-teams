class AddAboutToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :about, :text
    add_column :users, :experience, :string
    add_column :users, :cv, :string
  end
end
