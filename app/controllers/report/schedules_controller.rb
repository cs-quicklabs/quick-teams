class Report::SchedulesController < Report::BaseController
  def available
    @employees = User.for_current_account.active.billable.includes({ schedules: :project }, :role, :discipline, :job).order(:job_id).decorate
    @employees = @employees.select { |e| e.overall_occupancy < 100 }
  end

  def overburdened
    @employees = User.for_current_account.active.billable.includes({ schedules: :project }, :role, :discipline, :job).order(:first_name).decorate
    @employees = @employees.select { |e| e.overall_occupancy > 100 }
  end

  def shared
    @employees = User.for_current_account.active.billable.includes({ schedules: :project }, :role, :discipline, :job).order(:first_name).decorate
    @employees = @employees.select { |e| e.schedules.size > 1 }
  end

  def available_next_month
    @employees = User.for_current_account.active.billable.includes({ schedules: :project }, :role, :discipline, :job).order(:job_id).decorate
    @employees = @employees.select { |e| schedule_not_planned_after_month(e) }
  end

  def schedule_not_planned_after_month(employee)
    return false if employee.schedules.size == 0 or employee.overall_occupancy < 60 #selected occupied resources only
    planned_till = employee.schedules.try(:maximum, :ends_at)
    return true if planned_till.nil?

    planned_till < Date.today + 30.days
  end
end
