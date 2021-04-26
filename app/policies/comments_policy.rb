class CommentsPolicy < Struct.new(:user, :comments)
  def create?
    user.admin?
  end

  def index?
    user.admin?
  end
end
