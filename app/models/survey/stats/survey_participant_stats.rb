class Survey::Stats::SurveyParticipantStats < Survey::Stats::SurveyStats
  def initialize(survey, participant)
    super(survey)
    @participant = participant
  end

  def stats_for(question)
    attempts = survey.attempts.where(participant_id: participant.id, participant_type: participant.class.name)
    answers = Survey::Answer.where(attempt_id: attempts.ids, question: question)
    total_responses = answers.count
    average_score = 0.0
    if total_responses > 0
      average_score = answers.map(&:score).sum.to_f / total_responses
    end
    return total_responses, average_score
  end

  def all_attempts
    @survey.attempts.where(participant_id: @participant.id, participant_type: @participant.class.name)
  end
end
