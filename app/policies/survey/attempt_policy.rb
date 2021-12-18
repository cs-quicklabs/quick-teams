class Survey::AttemptPolicy < Survey::BaseSurveyPolicy
  def index?
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def edit?
    attempt = record.first
    user.admin? or (attempt.actor == user and not attempt.submitted?)
  end

  def show?
    attempt = record.first
    attempt.participant_type == "Project" ? show_project_survey_attempt? : show_employee_survey_attempt?
  end

  def update?
    edit?
  end

  def preview?
    show?
  end

  def destroy?
    edit?
  end

  private

  def show_project_survey_attempt?
    attempt = record.first
    project = attempt.participant
    user.admin? or user.is_manager?(project)
  end

  def show_employee_survey_attempt?
    attempt = record.first
    employee = attempt.participant
    user.admin? or user.subordinate?(employee) or user.project_participant?(employee) or attempt.actor == user
  end
end
