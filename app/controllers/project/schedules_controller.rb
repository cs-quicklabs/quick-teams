class Project::SchedulesController < Project::BaseController
  before_action :set_schedule, only: %i[ update destroy edit ]

  def index
    authorize [:project, Schedule]
    @schedules = Schedule.where(project: @project).includes({ user: [:role, :job] })
    @schedule = Schedule.new
  end

  def update
    authorize @schedule

    schedule = UpdateSchedule.call(@schedule, @project, User.find_by(id: schedule_params["user_id"]), schedule_params, current_user).result

    respond_to do |format|
      if schedule.errors.empty?
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "project/schedules/schedule", locals: { schedule: @schedule.decorate }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "schedules/form", locals: { schedule: @schedule }) }
      end
    end
  end

  def create
    authorize [:project, Schedule]

    schedule = UpdateSchedule.call(Schedule.new, @project, User.find_by(id: schedule_params["user_id"]), schedule_params, current_user).result

    respond_to do |format|
      if schedule.persisted?
        format.html { redirect_to project_schedules_path(@project), notice: "Participant was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Schedule.new, partial: "project/schedules/form", locals: { schedule: schedule }) }
      end
    end
  end

  def edit
    authorize @schedule
  end

  def destroy
    authorize @schedule

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
    params.require(:schedule).permit(:user_id, :starts_at, :discipline_id, :ends_at, :occupancy)
  end
end
