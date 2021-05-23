class ReportPolicy < Struct.new(:user, :report)
  def index?
    user.admin?
  end
end
