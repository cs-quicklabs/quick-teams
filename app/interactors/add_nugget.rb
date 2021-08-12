class AddNugget < Patterns::Service
    def initialize(actor, params)
        @nugget = Nugget.new(params)
        @actor = actor
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
        nugget.user_id = actor.id
        nugget.published = false
        nugget.published_on = DateTime.now
        nugget.save!
      end
    
      def add_event
        user.events.create( action: "created", action_for_context: "added new nugget in project", trackable: nugget)
      end
    
      attr_reader :actor, :nugget
  end
  