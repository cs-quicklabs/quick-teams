class User:: NuggetPolicy < User::BaseUserPolicy
    def create?
      true
    end
    def edit?
        true
      end
    
      def index?
        true
      end
 
      def show?
        true
      end
      def destroy?
        true
      end
      def update?
        true
      end
      def new? 
        true
      end
  end