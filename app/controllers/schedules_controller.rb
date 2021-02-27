class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[ update create destroy edit ]
  before_action :set_schedule, only: %i[ update destroy edit ]

  def index
    employees = User.includes({ schedules: :project }, :role, :discipline, :job).order(:first_name)
    @employees = UserDecorator.decorate_collection(employees)
  end

  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "projects/schedule/schedule", locals: { message: "Schedule was updated successfully", schedule: @schedule.decorate }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "schedules/edit", locals: { schedule: @schedule }) }
      end
    end
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.project_id = @project.id

    respond_to do |format|
      if @schedule.save
        @schedule = Schedule.new
        format.html { redirect_to project_participants_path(@project), notice: "Participant was added successfully." }
        #format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "projects/schedule/form", locals: { message: "Participant was added.", schedule: @schedule }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "projects/schedule/form", locals: { schedule: @schedule }) }
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

  def build_form
    @form = ChangePasswordForm.new(@user)
  end

  def set_project
    @project = Project.find(params["project_id"])
  end

  def set_schedule
    @schedule = Schedule.find(params["id"])
  end

  def schedule_params
    params.require(:schedule).permit(:user_id, :starts_at, :discipline_id, :ends_at, :occupancy)
  end
end
