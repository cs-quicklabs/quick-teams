class KbPolicy < ApplicationPolicy
    def destroy?
      edit?
    end
  
    def edit?
      return true if user.admin?
    end
  
    def update?
      edit?
    end
  
    def new?
      edit?
    end

    def create?
      edit?
    end

    def index?
        true
    end
  end
  