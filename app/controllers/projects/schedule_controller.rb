class Projects::ScheduleController < ApplicationController
  before_action :set_project, only: %i[ index show edit update destroy ]

  def index
    @schedules = ScheduleDecorator.decorate_collection(Schedule.where(project: @project))
    @schedule = Schedule.new
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params["project_id"]).decorate
  end
end
