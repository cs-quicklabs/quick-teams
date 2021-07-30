class UpdateNugget < Patterns::Service
    def initialize(user, params)
      @users = project
      @nugget = @user.nuggets.new params
    end
  
    def call
      begin
        add_nugget
        add_event
      rescue
        nugget
      end
  
      nugget
    end
  
    private
  
    def add_nugget
      nugget.published = true
      nugget.save!
    end
  
    def add_event
      user.events.create( action: "created", action_for_context: "added new nugget in project", trackable: nugget)
    end
  
    attr_reader :user, :nugget
  end