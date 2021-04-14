class ProjectTimesheetsStats
  def initialize(project, type)
    @title = "Last Week's Performance"
    @total_hours = 100
    @billable_hours = 90
    @billed_hours = 40
    @contributors = User.for_current_account.active
  end

  attr_accessor :total_hours, :billable_hours, :billed_hours, :title, :contributors
end
