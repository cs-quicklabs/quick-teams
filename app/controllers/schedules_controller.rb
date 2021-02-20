class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def update
    respond_to do |format|
      if @user.update(schedule_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/profile", locals: { message: "User was updated successfully", user: @user }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/profile", locals: { user: @user }) }
      end
    end
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.project_id = @project.id

    respond_to do |format|
      if @schedule.save
        @schedule = Schedule.new
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "projects/schedule/form", locals: { message: "Participant was added.", schedule: @schedule }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "projects/schedule/form", locals: { schedule: @schedule }) }
      end
    end
  end

  private

  def build_form
    @form = ChangePasswordForm.new(@user)
  end

  def set_project
    @project = Project.find(params['project_id'])
  end

  def schedule_params
    params.require(:schedule).permit(:user_id, :starts_at, :discipline_id, :ends_at, :occupancy)
  end

end
