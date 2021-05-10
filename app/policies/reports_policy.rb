class ReportsPolicy < Struct.new(:user, :reports)
  def index?
    user.admin?
  end
end
