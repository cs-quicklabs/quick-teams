class CreateUser < Patterns::Service
  PASSWORD_LENGTH = 10

  def initialize(params, actor, account, invite)
    @user = User.new(params)
    @actor = actor
    @account = account
    @invite = invite
  end

  def call
    create_user
    invite_user
    add_event
    user
  rescue StandardError
    user
  end

  private

  attr_reader :user, :actor, :account, :invite

  def create_user
    user.account = account
    user.password = SecureRandom.alphanumeric(PASSWORD_LENGTH)
    user.skip_confirmation!
    user.save!
  end

  def invite_user
    user.invite! if invite == "1"
  end

  def add_event
    user.events.create!(
      user: actor,
      action: "created",
      action_for_context: "added new employee",
      trackable: user,
    )
  end
end
