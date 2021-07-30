class NuggetsPolicy < Struct.new(:user, :nuggets)
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
      def destroy
        true
      end
  end