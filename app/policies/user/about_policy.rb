class User::AboutPolicy < ApplicationPolicy
  def index?
    user.admin?
  end
  def edit_employee?
    user.admin?
  end
  def update_employee_about?
    user.admin?
  end
end
