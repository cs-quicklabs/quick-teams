class ActivateUser < Patterns::Service
  def initialize(user)
    @user = user
  end

  def call
    activate
  end

  private

  def activate
    user.active = true
    user.deactivated_on = nil
    user.save
  end

  attr_reader :user
end
