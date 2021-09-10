class Survey::ReportPolicy < Survey::BaseSurveyPolicy
  def index?
    user.member?
  end

  
end
