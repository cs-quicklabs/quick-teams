class AddLinkToDocuments < ActiveRecord::Migration[6.1]
  def change
    add_column :documents, :link, :string
  end
end
