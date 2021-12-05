class Project::TodoPolicy < Project::BaseProjectPolicy
      def update?
    edit?
  end
   def show?
    create?
  end
    def create?
    project = record.first
    return false if project.archived?
   return true if user.admin? or user.is_manager?(project)
  end
   def index?
  create?
  end

  def edit?
    project = record.first
    todo = record.last
    return false if project.archived?
     return true if user.admin? or user.is_manager?(project)
  end
  def destroy?
    edit?
  end
end
