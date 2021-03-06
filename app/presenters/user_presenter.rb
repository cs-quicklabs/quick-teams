class UserPresenter
  def initialize(user)
    @user = user
  end

  def show_add_feedback_form
    user.active
  end

  private

  attr_accessor :user
end
