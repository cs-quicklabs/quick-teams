class DestroyUser < Patterns::Service
  def initialize(user)
    @user = user
    @transferred_to = Preference.transfer_data_to_admin(user.account)
  end

  def call
    begin
      transfer_kbs
      transfer_surveys
      transfer_nuggets
      transfer_templates
      transfer_documents
      transfer_feedbacks
      transfer_goals
      transfer_risks
      transfer_todos
      transfer_surveys
      transfer_comments
      delete_events
      user.destroy
    rescue Exception => e
      return false
    end
    true
  end

  private

  def transfer_kbs
    Kb.where(user: user).update_all(user_id: transferred_to.id)
  end

  def transfer_nuggets
    Nugget.where(user: user).update_all(user_id: transferred_to.id)
    NuggetsUser.where(user_id: user.id).destroy_all
  end

  def transfer_surveys
    Survey::Survey.where(actor: user).update_all(actor_id: transferred_to.id)
  end

  def transfer_templates
    Template.where(user: user).update_all(user_id: transferred_to.id)
  end

  def transfer_documents
    Document.where(user: user).update_all(user_id: transferred_to.id)
  end

  def transfer_feedbacks
    Feedback.where(user: user).update_all(user_id: transferred_to.id)
  end

  def transfer_goals
    Goal.where(user: user).update_all(user_id: transferred_to.id)
  end

  def transfer_risks
    Risk.where(user: user).update_all(user_id: transferred_to.id)
  end

  def transfer_todos
    Todo.where(user: user).update_all(user_id: transferred_to.id)
  end

  def transfer_surveys
    Survey::Attempt.where(actor: user).update_all(actor_id: transferred_to.id)
  end

  def transfer_comments
    Comment.where(user_id: user.id).update_all(user_id: transferred_to.id)
  end

  def delete_events
    Event.where(user_id: user.id).delete_all
    Event.where(trackable_id: user.id).delete_all
  end

  attr_reader :user, :transferred_to
end
