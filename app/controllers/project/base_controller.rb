class Project::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[ index show edit update destroy create index ]

  def set_project
    @project = Project.find(params["project_id"]).decorate
  end
end
