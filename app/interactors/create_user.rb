class CreateUser < Patterns::Service
  CHARS = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a

  def initialize(params)
    @user = User.new(params)
  end

  def call
    password = random_password
    user.account = Current.account
    user.password = password
    user.save
    user
  end

  private

  def random_password(length = 10)
    CHARS.sort_by { rand }.join[0...length]
  end

  attr_reader :user
end
