class Survey::Stats::EmployeeKpiStats < Survey::Stats::SurveyStats
  def initialize(survey, participant, show_own_attempts = false)
    super(survey)
    @participant = participant
    @show_own_attempts = show_own_attempts
  end

  def all_attempts
    @show_own_attempts ? attempts_by_self : attempts_by_others
  end

  def survey_ids
    Survey::Survey.where(survey_for: :user, survey_type: :kpi)
  end

  def attempts_by_self
    Survey::Attempt.where(survey_id: survey_ids, participant_id: @participant.id, participant_type: @participant.class.name, actor_id: @participant.id)
  end

  def attempts_by_others
    Survey::Attempt.where(survey_id: survey_ids, participant_id: @participant.id, participant_type: @participant.class.name).where.not(actor_id: @participant.id)
  end
end
