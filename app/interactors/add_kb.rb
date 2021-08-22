class AddKb < Patterns::Service
    def initialize(params, actor)
      @kb = Kb.new params
      @actor = actor
    end
  
    def call
      begin
        add_kb
        add_event
      rescue
        kb
      end
      kb
    end
  
    private
  
    def add_kb
      kb.user_id = actor.id
      kb.save!
    end
  
    def add_event
      project.events.create(user: actor, action: "knowledge base", action_for_context: "added new knowledge base", trackable: kb)
    end
  
    attr_reader :kb, :actor
  end
  