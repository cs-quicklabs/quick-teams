class Project::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[ index show edit update destroy create ]
  before_action :set_statuses, only: %i[index]
  before_action :set_tags, only: %i[index]
  after_action :verify_authorized
  include Pagy::Backend

  LIMIT = 20

  def pagy_nil_safe(collection, vars = {})
    pagy = Pagy.new(count: collection.count(:all), page: params[:page], **vars)
    return pagy, collection.offset(pagy.offset).limit(pagy.items) if collection.respond_to?(:offset)
    return pagy, collection
  end

  def set_project
    @project ||= Project.find(params["project_id"]).decorate
  end

  def set_statuses
    @statuses ||= ProjectStatus.all.order(:name)
  end

  def set_tags
    @tags ||= ProjectTag.all.order(:name)
  end
end
