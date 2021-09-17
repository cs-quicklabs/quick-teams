class AddKpiToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :kpi_id, :integer, foreign_key: { to_table: :survey_surveys }
  end
end
