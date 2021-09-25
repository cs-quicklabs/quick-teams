class SurveyParticipantStatsReflex < ApplicationReflex
  def summary
    question = Survey::Question.find(element.dataset["question-id"])
    participant_type = element.dataset["participant-type"]
    participant = participant_type.capitalize.constantize.find(element.dataset["participant-id"])
    total_responses, average_score = Survey::Stats::SurveyParticipantStats.new(question.survey, participant).stats_for(question)
    color, message = color_message_for(total_responses, average_score)
    morph "#summary_#{question.id}", render(partial: "shared/surveys/summary", locals: { message: message, color: color })
  end

  def color_message_for(total_responses, average_score)
    color = "bg-gray-100"
    message = "No answer to this question yet."
    if total_responses > 0
      message = "Average score is #{average_score.round(1)} in #{total_responses} responses."
    end

    if average_score >= 8
      color = "bg-green-100"
    elsif average_score >= 4
      color = "bg-yellow-100"
    else
      color = "bg-red-100"
    end
    return color, message
  end
end
