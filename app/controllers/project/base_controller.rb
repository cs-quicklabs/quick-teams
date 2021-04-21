class Project::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[ index show edit update destroy create index ]
  before_action :set_statuses, only: %i[index]
  before_action :set_tags, only: %i[index]

  def set_project
    @project = Project.find(params["project_id"]).decorate
  end

  def set_statuses
    @statuses = ProjectStatus.all.order(:name)
  end

  def set_tags
    @tags = ProjectTag.all.order(:name)
  end
end
