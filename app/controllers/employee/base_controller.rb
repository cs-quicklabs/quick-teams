class Employee::BaseController < BaseController
  before_action :set_employee, only: %i[index show edit update create destroy new show_skills add_skill]
  before_action :set_statuses, only: %i[index]
  before_action :set_tags, only: %i[index]
  after_action :verify_authorized
  include Pagy::Backend

  private

  def set_employee
    @employee ||= User.find(params["employee_id"])
  end

  def set_statuses
    @statuses ||= PeopleStatus.all.order(:name)
  end

  def set_tags
    @tags ||= PeopleTag.all.order(:name)
  end
end
