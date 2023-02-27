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
    space_users = space.users
    new_space_users = users - space_users.pluck(:id)
    user = space_users.pluck(:id) - users
    if !new_space_users.empty?
      space_users << User.where("id IN (?)", new_space_users)
    end
    if !space_users.include?(actor)
      space_users << actor
    end

    if !user.empty?
      space_users.delete(User.where("id IN (?)", user))
    end
  end

  attr_reader :space, :actor, :users, :params
end
