class HomePolicy < Struct.new(:user, :home)
  def index?
    user.admin?
  end
end
