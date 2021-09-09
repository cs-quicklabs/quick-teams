class Survey::BaseController < BaseController
  before_action :set_survey, only: %i[index show edit update create destroy]
  after_action :verify_authorized
  include Pagy::Backend

  LIMIT = 20

  private

  def set_survey
    @survey ||= Survey.find(params[:id])
  end
end
