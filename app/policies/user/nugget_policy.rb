class User::NuggetPolicy < User::BaseUserPolicy
  def index?
    true
  end

  def show?
    employee = record.first
    nugget = record.second
    employee.published_nuggets.include?(nugget)
  end
end
