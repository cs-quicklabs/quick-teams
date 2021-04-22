class CommentsPolicy < Struct.new(:user, :comments)
  def create?
    user.admin?
  end
end
