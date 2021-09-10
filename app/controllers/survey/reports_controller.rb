class Survey::ReportsController < Survey::BaseController
   before_action :set_survey, only: [:checklist, :submit, :score, :download, :pdf]
   before_action :set_attempt, only: [:checklist, :submit, :score, :download, :pdf]


  def checklist
     authorize [:survey, :report]
    @attempt = Survey::Attempt.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@attempt.participant.first_name}_#{@attempt.survey.name}",
               page_size: "A4",
               template: "survey/pdf/checklist.html.erb",
               layout: "pdf.html",
               lowquality: true,
               zoom: 1,
               dpi: 75
      end
    end
  end

  def score
         authorize [:survey, :report]
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@attempt.participant.first_name}_#{@attempt.survey.name}",
               page_size: "A4",
               template: "survey/pdf/score.html.erb",
               layout: "pdf.html",
               lowquality: true,
               zoom: 1,
               dpi: 75
      end
    end
  end

  def submit
      authorize [:survey, :report]
    @attempt = Survey::Attempt.find(params[:id])
    @attempt.update("comment": params[:comment], "submitted":true)
    redirect_to employee_surveys_path(@attempt.participant)
  end

  def download
         authorize [:survey, :report]
   @attempt = Survey::Attempt.find(params[:id])
    @attempt.update_attribute("comment", params[:comment], "submitted":true)
    if @attempt.survey.checklist?
      redirect_to survey_report_checklist_pdf_path(@survey, @attempt, format: :pdf)
    else
      redirect_to survey_report_score_pdf_path(@survey, @attempt, format: :pdf)
    end
  end

    def pdf
         authorize [:survey, :report]
  if @attempt.survey.checklist?
      redirect_to survey_report_checklist_pdf_path(@survey, @attempt, format: :pdf)
    else
      redirect_to survey_report_score_pdf_path(@survey, @attempt, format: :pdf)
    end
  end

  private

  def set_survey
     @survey = Survey::Survey.find(params[:survey_id])
  end
def set_attempt
     @attempt = Survey::Attempt.find(params[:id])
  end
end
