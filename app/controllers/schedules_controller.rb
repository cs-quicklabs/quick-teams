class SchedulesController < BaseController
  include Pagy::Backend

  before_action :set_project, only: %i[ update create destroy edit ]
  before_action :set_schedule, only: %i[ update destroy edit ]

  def index
    authorize :schedules

    employees = employees_for_schedule

    @jobs = Job.all.order(:name)
    @roles = Role.all.order(:name)
    @free_resources = free_of_schedule(employees).round(2)
    @total_resources = employees.count

    @pagy, @employees = pagy_nil_safe(params, employees, items: 20)
    if stale?(@employees)
      respond_to do |format|
        format.html
        format.json {
          render json: { entries: render_to_string(partial: "schedules/schedule", formats: [:html], collection: @employees, as: :employee, cached: true),
                         pagination: render_to_string(partial: "shared/paginator", formats: [:html], locals: { pagy: @pagy }) }
        }
      end
    end
  end

  def employees_for_schedule
    employees = User.for_current_account.active.includes({ schedules: :project }, :role, :discipline, :job, :status).order(:first_name)
    if params[:job]
      employees = employees.where(job: params[:job])
    else
      employees = employees.where(billable: true)
    end
  end

  def free_of_schedule(employees)
    free_resources = 0.0
    if employees.count > 0
      free_resources = (Float((employees.count * 100) - employees.map { |employee| employee.decorate.overall_occupancy }.inject(:+)) / 100)
    end
    free_resources
  end

  def update
    authorize :schedules

    @schedule = UpdateSchedule.call(@schedule, @project, current_user, schedule_params, current_user).result

    respond_to do |format|
      if @schedule.errors.empty?
        render turbo_stream: turbo_stream.prepend("schedules", partial: "project/schedules/schedule", locals: { schedule: @schedule }) +
                             turbo_stream.replace(Schedule.new, partial: "project/schedules/form", locals: { schedule: Schedule.new })
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

  def occupancy
    authorize :schedules

    if params[:id]
      job = Job.find(params[:id])
      @occupancy = JobOccupancy.occupancy_for_job(job)
    else
      @occupancy = JobOccupancy.occupancy_for_account(current_user.account)
    end
    render "shared/occupancy"
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
