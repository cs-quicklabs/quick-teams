class Employee::SchedulesController < Employee::BaseController
  before_action :set_schedule, only: %i[ update destroy edit ]

  def index
    authorize @employee, :show_schedules?

    @schedules = Schedule.where(user: @employee).includes(:project, :user).order(created_at: :desc)
    @schedule = Schedule.new

    fresh_when @schedules
  end

  def update
    authorize [:employee, @schedule]

    schedule = UpdateSchedule.call(@schedule, Project.find_by(id: schedule_params["project_id"]), @employee, schedule_params, current_user).result

    respond_to do |format|
      if schedule.errors.empty?
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "employee/schedules/schedule", locals: { schedule: @schedule }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "employee/schedules/form", locals: { schedule: @schedule }) }
      end
    end
  end

  def create
    authorize [:employee, Schedule]

    @schedule = UpdateSchedule.call(Schedule.new, Project.find_by(id: schedule_params["project_id"]), @employee, schedule_params, current_user).result

    respond_to do |format|
      if @schedule.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:schedules, partial: "employee/schedules/schedule", locals: { schedule: @schedule }) +
                               turbo_stream.replace(Schedule.new, partial: "employee/schedules/form", locals: { schedule: Schedule.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Schedule.new, partial: "employee/schedules/form", locals: { schedule: schedule }) }
      end
    end
  end

  def edit
    authorize [:employee, @schedule]
  end

  def destroy
    authorize [:employee, @schedule]

    @schedule.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@schedule) }
    end
  end

  private

  def set_schedule
    @schedule ||= Schedule.find(params["id"])
  end

  def schedule_params
    params.require(:schedule).permit(:project_id, :starts_at, :discipline_id, :ends_at, :occupancy)
  end
end
