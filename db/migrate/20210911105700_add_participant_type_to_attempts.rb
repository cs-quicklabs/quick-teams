class AddParticipantTypeToAttempts < ActiveRecord::Migration[6.1]
  def change
    add_column :survey_attempts, :participant_type, :string, null: false
  end
end
