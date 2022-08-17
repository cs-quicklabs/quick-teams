class ReportPolicy < Struct.new(:user, :report)
  def index?
    user.admin?
  end

  def employees_performance_pdf?
    user.admin?
  end
end
