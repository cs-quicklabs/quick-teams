class Employee::TeamPolicy < Struct.new(:user, :home)
  def index?
    user.admin? or user.lead?
  end
end
