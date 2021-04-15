class UserPresenter
  def initialize(user)
    @user = user
  end

  def show_add_feedback_form
    user.active
  end

  def show_add_timesheet_form(current_user)
    user.active && user.id == current_user.id
  end

  def show_timesheet_stats(current_user)
    !show_add_timesheet_form(current_user)
  end

  def show_timesheet_stats_menu(current_user)
    show_timesheet_stats(current_user) && user.active
  end

  private

  attr_accessor :user
end
