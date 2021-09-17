class Survey::ReportPolicy < Survey::BaseSurveyPolicy
  def checklist?
    true
  end

  def score?
    true
  end

  def submit?
    true
  end

  def download?
    true
  end

  def pdf?
    true
  end
end
