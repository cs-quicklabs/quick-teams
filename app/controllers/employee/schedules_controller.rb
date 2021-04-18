class Employee::SchedulesController < Employee::BaseController
  before_action :set_schedule, only: %i[ update destroy edit ]

  def index
    collection = Schedule.where(user: @employee).includes(:project, :user).order(created_at: :desc)
    @schedules = ScheduleDecorator.decorate_collection(collection)
    @schedule = Schedule.new
  end

  def update
    schedule = UpdateSchedule.call(@schedule, Project.find_by(id: schedule_params["project_id"]), @employee, schedule_params, current_user).result

    respond_to do |format|
      if schedule.errors.empty?
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "employee/schedules/schedule", locals: { schedule: @schedule.decorate }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "schedules/form", locals: { schedule: @schedule }) }
      end
    end
  end

  def create
    schedule = UpdateSchedule.call(Schedule.new, Project.find_by(id: schedule_params["project_id"]), @employee, schedule_params, current_user).result

    respond_to do |format|
      if schedule.persisted?
        format.html { redirect_to employee_schedules_path(@employee), notice: "Schedule was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Schedule.new, partial: "employee/schedules/form", locals: { schedule: schedule }) }
      end
    end
  end

  def edit
  end

  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to employee_schedules_path(@employee), notice: "Schedule was removed successfully." }
    end
  end

  private

  def set_schedule
    @schedule = Schedule.find(params["id"])
  end

  def schedule_params
    params.require(:schedule).permit(:project_id, :starts_at, :discipline_id, :ends_at, :occupancy)
  end
end
