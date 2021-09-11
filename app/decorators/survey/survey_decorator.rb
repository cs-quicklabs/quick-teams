class Survey::SurveyDecorator < Draper::Decorator
  delegate_all

  def survey_type_color
    if self.checklist?
      "yellow"
    elsif self.kpi?
      "green"
    elsif self.score?
      "gray"
    end
  end

  def survey_for_color
    if self.employee?
      "yellow"
    elsif self.client?
      "gray"
    elsif self.project?
      "gray"
    end
  end
  def display_survey_type
    
    if self.kpi?
      "KPIs"
    else 
      survey_type.titleize
    end
      
  end
end
