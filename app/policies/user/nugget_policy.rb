class User::NuggetPolicy < User::BaseUserPolicy
  def show?
    employee = record.first
    # show only if nugget has been published for this user
    employee.published_nuggets.include?(record.last)
  end
end
