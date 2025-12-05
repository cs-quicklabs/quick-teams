class DestroyUser < Patterns::Service
  TRANSFERABLE_MODELS = {
    "Survey::Survey" => :actor_id,
    "Template" => :user_id,
    "Document" => :user_id,
    "Feedback" => :user_id,
    "Goal" => :user_id,
    "Risk" => :user_id,
    "Todo" => :user_id,
    "Survey::Attempt" => :actor_id,
    "Message" => :user_id,
  }.freeze

  def initialize(user)
    @user = user
    @transferred_to = Preference.transfer_data_to_admin(user.account)
  end

  def call
    transfer_all_records
    transfer_comments
    transfer_spaces
    transfer_ticket_labels
    delete_message_comments
    delete_events
    user.destroy!
    true
  rescue StandardError
    false
  end

  private

  attr_reader :user, :transferred_to

  def transfer_all_records
    TRANSFERABLE_MODELS.each do |model_name, foreign_key|
      model_name.constantize
                .where(foreign_key => user.id)
                .update_all(foreign_key => transferred_to.id)
    end
  end

  def transfer_comments
    Comment.where(user_id: user.id).update_all(user_id: transferred_to.id)
  end

  def transfer_spaces
    user_spaces = Space.where(user: user)
    user_spaces.update_all(user_id: transferred_to.id)
    user_spaces.each { |space| space.users << transferred_to }
  end

  def transfer_ticket_labels
    user.ticket_labels.update_all(user_id: transferred_to.id)
  end

  def delete_message_comments
    MessageComment.where(user: user).delete_all
  end

  def delete_events
    Event.where(user_id: user.id).delete_all
    Event.where(trackable_id: user.id).delete_all
  end
end
