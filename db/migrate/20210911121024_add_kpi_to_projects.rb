class AddKpiToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :kpi_id, :integer, foreign_key: { to_table: :survey_surveys }
  end
end
