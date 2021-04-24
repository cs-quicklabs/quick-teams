class TimesheetsPolicy < Struct.new(:user, :timesheets)
  def index?
    user.admin?
  end
end
