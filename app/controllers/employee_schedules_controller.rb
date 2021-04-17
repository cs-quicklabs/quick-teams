class EmployeeSchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_employee, only: %i[ update create destroy edit ]
  before_action :set_schedule, only: %i[ update destroy edit ]

  def index
    projects = Project.active.includes({ schedules: :employee }, :discipline, :participants, :manager).order(:name)
    if params[:discipline]
      @projects = ProjectDecorator.decorate_collection(projects.where(discipline: params[:discipline]))
    else
      @projects = ProjectDecorator.decorate_collection(projects)
    end
    @disciplines = Discipline.all.order(:name)
    fresh_when @projects
  end

  def update
    schedule = UpdateEmployeeSchedule.call(@schedule, @employee, current_user, schedule_params, current_user).result

    respond_to do |format|
      if schedule.errors.empty?
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "employee/schedule/schedule", locals: { schedule: @schedule.decorate }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "schedules/form", locals: { schedule: @schedule }) }
      end
    end
  end

  def create
    schedule = UpdateEmployeeSchedule.call(Schedule.new, @employee, current_user, schedule_params, current_user).result

    respond_to do |format|
      if schedule.persisted?
        format.html { redirect_to employee_participants_path(@employee), notice: "Participant Project was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Schedule.new, partial: "employee/schedule/form", locals: { schedule: schedule }) }
      end
    end
  end

  def edit
  end

  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to employee_participants_path(@employee), notice: "Participant Project was removed successfully." }
    end
  end

  private

 def set_employee
    @employee = User.find(params["employee_id"]).decorate
  end

  def set_schedule
    @schedule = Schedule.find(params["id"])
  end

  def schedule_params
    params.require(:schedule).permit(:project_id, :starts_at, :discipline_id, :ends_at, :occupancy)
  end
end
