class ReportPolicy < Struct.new(:user, :report)
  def index?
    user.admin?
  end

  def performance_report?
    user.admin?
  end

  def generate?
    user.admin?
  end
end
