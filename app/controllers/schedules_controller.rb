class SchedulesController < BaseController
  before_action :authenticate_user!
  before_action :set_project, only: %i[ update create destroy edit ]
  before_action :set_schedule, only: %i[ update destroy edit ]

  def index
    authorize :schedules

    employees = User.for_current_account.active.includes({ schedules: :project }, :role, :discipline, :job).order(:first_name)
    if params[:job]
      @employees = employees.where(job: params[:job])
    else
      @employees = employees
    end
    @jobs = Job.all.order(:name)
    @roles = Role.all.order(:name)
    fresh_when @employees
  end

  def update
    authorize :schedules

    schedule = UpdateSchedule.call(@schedule, @project, current_user, schedule_params, current_user).result

    respond_to do |format|
      if schedule.errors.empty?
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "project/schedule/schedule", locals: { schedule: @schedule.decorate }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "schedules/form", locals: { schedule: @schedule }) }
      end
    end
  end

  def create
    authorize :schedules

    schedule = UpdateSchedule.call(Schedule.new, @project, current_user, schedule_params, current_user).result

    respond_to do |format|
      if schedule.persisted?
        format.html { redirect_to project_schedules_path(@project), notice: "Participant was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Schedule.new, partial: "project/schedule/form", locals: { schedule: schedule }) }
      end
    end
  end

  def edit
    authorize :schedules
  end

  def destroy
    authorize :schedules

    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to project_schedules_path(@project), notice: "Participant was removed successfully." }
    end
  end

  private

  def set_project
    @project ||= Project.find(params["project_id"])
  end

  def set_schedule
    @schedule ||= Schedule.find(params["id"])
  end

  def schedule_params
    params.require(:schedule).permit(:user_id, :starts_at, :discipline_id, :ends_at, :occupancy)
  end
end
