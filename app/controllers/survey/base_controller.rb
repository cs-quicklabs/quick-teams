class Survey::BaseController < BaseController
  before_action :set_survey, only: %i[show edit update destroy]
  include Pagy::Backend

  LIMIT = 20

  private

  def set_survey
    @survey ||= Survey.find(params[:id])
  end
end
