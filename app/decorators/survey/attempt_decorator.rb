class Survey::AttemptDecorator < Draper::Decorator
  delegate_all

  def display_score
    if survey.checklist?
      "#{score.to_s}/#{survey.questions.count.to_s}"
    else
      score.to_s + "%"
    end
  end

  def survey_url
    if self.participant.class.name == "Project"
      project_surveys_path(participant)
    elsif self.participant.class.name == "User"
      self.survey.kpi? ? employee_kpis_path(participant) : employee_surveys_path(participant)
    end
  end
end
