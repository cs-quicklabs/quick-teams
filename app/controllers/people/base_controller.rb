class People::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :set_employee, only: %i[show edit index create]

  private

  def set_employee
    @employee = User.find(params["person_id"]).decorate
  end
end
