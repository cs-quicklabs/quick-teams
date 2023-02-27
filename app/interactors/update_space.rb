class UpdateSpace < Patterns::Service
  def initialize(space, actor, users, params)
    @space = space
    @actor = actor
    @users = users.reject(&:blank?).map(&:to_i)
    @params = params
  end

  def call
    update_space
    update_space_users
    begin
    rescue
      space
    end
    space
  end

  def update_space
    @space.update(params)
  end

  def update_space_users
    space.users.clear
    space.users << User.where("id IN (?)", users)
    space.users << actor unless space.users.include?(actor)
  end

  attr_reader :space, :actor, :users, :params
end
