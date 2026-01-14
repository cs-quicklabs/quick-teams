class PlannersController < BaseController
  before_action :set_user, only: [:daily, :weekly]

  def daily
    authorize @user, :view_planner?
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @job_cards = JobCard.for_date(@date).where(user_id: @user.id)
    @grouped_cards = @job_cards.group_by { |card| [card.session, card.slot_start] }
  end

  def weekly
    authorize @user, :view_planner?
    @start_date = params[:week] ? Date.parse(params[:week]) : Date.today.beginning_of_week
    @dates = (@start_date..(@start_date + 4.days)).to_a
    @job_cards = JobCard.for_week(@start_date).where(user_id: @user.id)
    @grouped_cards = @job_cards.group_by { |card| [card.date  , card.session] }
  end

  private 

  def set_user
    @user = User.find(params["employee_id"])
  end
end
