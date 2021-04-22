class Employee::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :set_employee, only: %i[show edit update create destroy index]
  before_action :set_statuses, only: %i[index]
  after_action :verify_authorized

  private

  def set_employee
    @employee = User.find(params["employee_id"]).decorate
  end

  def set_statuses
    @statuses = PeopleStatus.all.order(:name)
  end
end
