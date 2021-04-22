class SchedulesPolicy < Struct.new(:user, :schedules)
  def index?
    user.admin?
  end
end
