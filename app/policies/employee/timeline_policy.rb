class Employee::TimelinePolicy < Struct.new(:user, :timeline)
  def index?
    user.admin?
  end
end
