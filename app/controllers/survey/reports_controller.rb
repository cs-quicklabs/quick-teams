class Survey::ReportsController < Survey::BaseController
  before_action :set_survey, only: [:checklist, :submit, :score, :download, :pdf]
  before_action :set_attempt, only: [:checklist, :submit, :score, :download, :pdf]

  def pdf
    authorize [:survey, :report]
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@attempt.participant.decorate.display_name}_#{@attempt.survey.name}",
               page_size: "A4",
               template: "survey/pdf/pdf.html.erb",
               layout: "pdf.html",
               lowquality: true,
               zoom: 1,
               dpi: 75
      end
    end
  end

  def submit
    authorize [:survey, :report]
    @attempt.update("comment": params[:survey_attempt][:comment], "submitted": true, score: @attempt.calculate_score)
    redirect_to resolve_redirect_path(@attempt)
  end

  def download
    authorize [:survey, :report]
    @attempt.update("comment": params[:survey_attempt][:comment], "submitted": true, score: @attempt.calculate_score)
    redirect_to survey_report_pdf_path(@survey, @attempt, format: :pdf)
  end

  private

  def set_survey
    @survey = Survey::Survey.find(params[:survey_id])
  end

  def set_attempt
    @attempt = Survey::Attempt.find(params[:id])
  end
end
