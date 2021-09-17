class AddTimeStampToAttempts < ActiveRecord::Migration[6.1]
  def change
    add_timestamps :survey_attempts, null: false
  end
end
