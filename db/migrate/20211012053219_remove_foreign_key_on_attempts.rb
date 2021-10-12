class RemoveForeignKeyOnAttempts < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :survey_attempts, column: :participant_id
  end
end
