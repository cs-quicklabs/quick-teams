class FixColumnName < ActiveRecord::Migration[6.1]

    def change
      rename_column :documents, :document__type, :document_type
    end
  end
