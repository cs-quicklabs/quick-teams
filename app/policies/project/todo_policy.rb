class Project::TodoPolicy < Project::BaseProjectPolicy
      def update?
    edit?
  end

  def edit?
    project = record.first
    report = record.last
    return false if project.archived?
     return true if user.admin? or !report.submitted?
  end
end
