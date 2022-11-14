class SearchPolicy < Struct.new(:user, :search)
  def people_projects?
    user.admin?
  end

  def employee_skills?
    true
  end

  def project_skills?
    true
  end

  def documents?
    user.admin?
  end

  def surveys?
    user.admin?
  end

  def deactivated?
    user.admin?
  end

  def archived?
    user.admin?
  end
end
