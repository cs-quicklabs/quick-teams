class AddSpace < Patterns::Service
  def initialize(space_params, actor, users)
    @space = Space.new(space_params)
    @actor = actor
    @users = users
  end

  def call
    begin
      create_space
      space_users
    rescue
      space
    end
    space
  end

  def create_space
    space.save!
  end

  def space_users
    space.users << User.where("id IN (?)", users)
  end

  attr_reader :space, :actor, :users
end
