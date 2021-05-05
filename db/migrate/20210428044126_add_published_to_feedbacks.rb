class AddPublishedToFeedbacks < ActiveRecord::Migration[6.1]
  def change
    add_column :feedbacks, :published, :boolean, default: false
  end
end
