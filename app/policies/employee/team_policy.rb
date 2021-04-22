class Employee::TeamPolicy < Struct.new(:user, :team)
  def index?
    user.admin? or user.lead?
  end
end
