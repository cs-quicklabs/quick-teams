class AddNugget < Patterns::Service
  def initialize(actor, params)
    @nugget = Nugget.new(params)
    @actor = actor
  end

  def call
    begin
      add_nugget
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

  attr_reader :actor, :nugget
end
