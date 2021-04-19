class Employee::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :set_employee, only: %i[show edit update create destroy index]

  private

  def set_employee
    @employee = User.find(params["employee_id"]).decorate
  end
end
