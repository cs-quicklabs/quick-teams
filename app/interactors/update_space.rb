class UpdateSpace < Patterns::Service
  def initialize(space, actor, users, params)
    @space = space
    @actor = actor
    @users = users
    @params = params
  end

  def call
    begin
      update_space
      update_space_users
    rescue
      space
    end
    space
  end

  def update_space
    @space.update(params)
  end

  def update_space_users
    space_users = space.users
    @users = User.where("id IN (?)", users)
    user = space_users - @users
    space_users.destroy user
    if !@users.nil?
      space_users << @users - space_users
      space_users << actor
    end
  end

  attr_reader :space, :actor, :users, :params
end
