class SearchPolicy < Struct.new(:user, :search)
  def people_projects?
    user.admin?
  end

  def skills?
    true
  end
end
