class AddcolumnToDocuments < ActiveRecord::Migration[6.1]
  def change
    add_column :documents, :comments, :string
  end
end
