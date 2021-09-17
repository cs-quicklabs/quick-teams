class Survey::BaseController < BaseController
  before_action :set_survey, only: %i[show edit update destroy]
  include Pagy::Backend

  LIMIT = 30

  private

  def set_survey
    @survey ||= Survey::Survey.find(params[:id])
  end
end
