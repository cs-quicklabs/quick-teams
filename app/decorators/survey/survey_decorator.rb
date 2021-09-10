class Survey::SurveyDecorator < Draper::Decorator
  delegate_all
  def survey_type_color
    if self.Checklist?
      "yellow"
    elsif self.Kpi?
      "green"
    elsif self.Score?
      "gray"
    end
end
    
def survey_for_color
    if self.Employee?
      "yellow"
    elsif self.Client?
      "gray"
    elsif self.Project?
     "gray" 
    end
end
end