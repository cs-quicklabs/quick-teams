class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[ update create destroy edit ]
  before_action :set_schedule, only: %i[ update destroy edit ]
  before_action :build_form, only: %i[create update]

  def index
    employees = User.for_current_account.active.includes({ schedules: :project }, :role, :discipline, :job).order(:first_name)
    if params[:job]
      @employees = UserDecorator.decorate_collection(employees.where(job: params[:job]))
    else
      @employees = UserDecorator.decorate_collection(employees)
    end
    @jobs = Job.all.order(:name)
    @roles = Role.all.order(:name)
    fresh_when @employees
  end

  def update
    respond_to do |format|
      if @form.submit(schedule_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "projects/schedule/schedule", locals: { message: "Schedule was updated successfully", schedule: @schedule.decorate }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "schedules/form", locals: { schedule: @schedule }) }
      end
    end
  end

  def create
    respond_to do |format|
      if @form.submit(schedule_params)
        format.html { redirect_to project_participants_path(@project), notice: "Participant was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "projects/schedule/form", locals: { schedule: @schedule, errors: @form }) }
      end
    end
  end

  def edit
  end

  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to project_participants_path(@project), notice: "Participant was removed successfully." }
    end
  end

  private

  def set_project
    @project = Project.find(params["project_id"])
  end

  def set_schedule
    @schedule = Schedule.find(params["id"])
  end

  def schedule_params
    params.require(:schedule).permit(:user_id, :starts_at, :discipline_id, :ends_at, :occupancy)
  end

  def build_form
    @schedule ||= Schedule.new
    @form = ScheduleForm.new(@project, @schedule, current_user)
  end
end
