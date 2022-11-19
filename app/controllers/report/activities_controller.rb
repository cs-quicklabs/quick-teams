class Report::ActivitiesController < Report::BaseController
  def index
    authorize :report
    @events = Event.includes(:user, :trackable, :eventable).where(created_at: params[:from_date].to_date...(params[:to_date]).to_date).order(created_at: :desc).limit(500)
  end
end
