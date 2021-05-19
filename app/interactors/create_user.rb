class CreateUser < Patterns::Service
  CHARS = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a

  def initialize(params, actor, account, invite)
    @user = User.new(params)
    @actor = actor
    @account = account
    @invite = invite
  end

  def call
    begin
      create_user
      invite_user
      add_event
    rescue
      user
    end

    user
  end

  private

  def create_user
    password = random_password
    user.account = account
    user.password = password
    user.save!
  end

  def invite_user
    user.invite! if @invite == "1"
  end

  def random_password(length = 10)
    CHARS.sort_by { rand }.join[0...length]
  end

  def add_event
    user.events.create(user: actor, action: "created", action_for_context: "added new employee", trackable: user)
  end

  attr_reader :user, :actor, :account
end
