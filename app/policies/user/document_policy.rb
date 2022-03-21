class User::DocumentPolicy < User::BaseUserPolicy
  def edit?
    # user should be active and
    # user should be admin or creator of document
    is_active? and (is_admin? or (record.last.user == record.first))
  end
end
