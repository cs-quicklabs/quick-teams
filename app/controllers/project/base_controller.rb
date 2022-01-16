class Project::BaseController < BaseController
  before_action :set_project, only: %i[ index show edit update destroy create new ]
  before_action :set_statuses, only: %i[index]
  before_action :set_tags, only: %i[index]
  after_action :verify_authorized
  include Pagy::Backend

  def set_project
    @project ||= Project.find(params["project_id"])
  end

  def set_statuses
    @statuses ||= ProjectStatus.all.order(:name)
  end

  def set_tags
    @tags ||= ProjectTag.all.order(:name)
  end
end
