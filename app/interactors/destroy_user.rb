class DestroyUser < Patterns::Service
  def initialize(user)
    @user = user
    @transferred_to = User.where(account: user.account, permission: :admin).first
  end

  def call
    begin
      transfer_kbs
      transfer_surveys
      transfer_nuggets
      transfer_templates
      user.destroy
    rescue
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

  attr_reader :user, :transferred_to
end
