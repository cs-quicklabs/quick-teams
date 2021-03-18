class CreateUser < Patterns::Service
  CHARS = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a

  def initialize(params, actor)
    @user = User.new(params)
    @actor = actor
  end

  def call
    create_user
    add_event
    user
  end

  private

  def create_user
    password = random_password
    user.account = Current.account
    user.password = password
    user.save
  end

  def random_password(length = 10)
    CHARS.sort_by { rand }.join[0...length]
  end

  def add_event
    user.events.create(user: actor, action: "added a new employee.", action_for_context: "added new employee")
  end

  attr_reader :user, :actor
end
