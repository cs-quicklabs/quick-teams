class AddCultureKpiToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :culture_kpi_id, :integer
    add_foreign_key :users, :survey_surveys, column: :culture_kpi_id
  end
end
