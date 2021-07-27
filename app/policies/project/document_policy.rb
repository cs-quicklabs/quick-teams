class Project::DocumentPolicy < ApplicationPolicy

    def create?
      user.admin?
    end
  
    def index?
      user.admin?
    end
  
    def show?
      user.admin?
    end
  
    def destroy?
      true
    end
  end
  