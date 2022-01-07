class Survey::Stats::SurveyParticipantStats < Survey::Stats::SurveyStats
  def initialize(survey, participant, show_own_attempts = false)
    super(survey)
    @participant = participant
    @show_own_attempts = show_own_attempts
  end

  def all_attempts
    @show_own_attempts ? attempts_by_self : attempts_by_others
  end

  def attempts_by_self
    @survey.attempts.where(participant_id: @participant.id, participant_type: @participant.class.name, actor_id: @participant.id)
  end

  def attempts_by_others
    @survey.attempts.where(participant_id: @participant.id, participant_type: @participant.class.name).where.not(actor_id: @participant.id)
  end
end
