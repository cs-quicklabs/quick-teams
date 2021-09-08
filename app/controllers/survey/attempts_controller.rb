class Survey::AttemptsController < ApplicationController
  before_action :set_survey, only: [:new, :create]

  def index
  end

  def new
    @attempt = Attempt.new
  end

  def create
    @participant = Participant.create(name: params[:name], email: params[:email])
    @attempt = Attempt.create(survey: @survey, participant: @participant)
    redirect_to survey_new_attempt_path(@attempt)
  end

  def show
    @attempt = Attempt.find(params[:id])
  end

  def submit
    @attempt = Attempt.find(params[:id])
    if @attempt.survey.survey_type == 0
      redirect_to survey_checklist_report_path(@attempt, format: :html)
    else
      redirect_to survey_score_report_path(@attempt, format: :html)
    end
  end

  private

  def set_survey
    @survey ||= Survey.find(params[:id])
  end
end
