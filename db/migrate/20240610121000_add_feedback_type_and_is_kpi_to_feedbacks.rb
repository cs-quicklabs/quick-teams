class AddFeedbackTypeAndIsKpiToFeedbacks < ActiveRecord::Migration[6.0]
  def change
    add_column :feedbacks, :feedback_type, :integer, default: 0, null: false
    add_column :feedbacks, :is_kpi, :boolean, default: false, null: false
  end
end
