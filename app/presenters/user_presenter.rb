class UserPresenter
  def initialize(user)
    @user = user
  end

  def show_add_timesheet_form(visiter)
    user.active && (user.id == visiter.id) && user.projects.size > 0
  end

  def show_timesheet_stats(visiter)
    !show_add_timesheet_form(visiter)
  end

  def show_timesheet_stats_menu(visiter)
    show_timesheet_stats(visiter) && user.active
  end

  def show_add_goal_form
    user.active
  end

  private

  attr_accessor :user
end
