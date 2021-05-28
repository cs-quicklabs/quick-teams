class ReportsController < BaseController
  def index
    authorize :reports
  end
end
