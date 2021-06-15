class Project::SchedulesController < Project::BaseController
  before_action :set_schedule, only: %i[ update destroy edit ]

  def index
    authorize [:project, Schedule]

    @schedule = Schedule.new
    @schedules = Schedule.where(project: @project).includes({ user: [:role, :job] }).order(created_at: :desc)

    fresh_when @schedules + [@project]
  end

  def update
    authorize [:project, @schedule]

    @schedule = UpdateSchedule.call(@schedule, @project, User.find_by(id: schedule_params["user_id"]), schedule_params, current_user).result

    respond_to do |format|
      if @schedule.errors.empty?
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "project/schedules/schedule", locals: { schedule: @schedule }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "schedules/form", locals: { schedule: @schedule }) }
      end
    end
  end

  def create
    authorize [:project, Schedule]

    @schedule = UpdateSchedule.call(Schedule.new, @project, User.find_by(id: schedule_params["user_id"]), schedule_params, current_user).result

    respond_to do |format|
      if @schedule.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:schedules, partial: "project/schedules/schedule", locals: { schedule: @schedule }) +
                               turbo_stream.replace(Schedule.new, partial: "project/schedules/form", locals: { schedule: Schedule.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Schedule.new, partial: "project/schedules/form", locals: { schedule: @schedule }) }
      end
    end
  end

  def edit
    authorize [:project, @schedule]
  end

  def destroy
    authorize [:project, @schedule]

    @schedule = RemoveSchedule.call(@schedule, current_user).result
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
