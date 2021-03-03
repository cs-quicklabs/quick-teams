class AddCritiquableToFeedback < ActiveRecord::Migration[6.1]
  def change
    add_reference :feedbacks, :critiquable, polymorphic: true, null: false
  end
end
