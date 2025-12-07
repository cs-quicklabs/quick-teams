class SurveyParticipantStatsReflex < ApplicationReflex
  def summary
    total_responses, average_score = fetch_stats
    color, message = color_message_for(total_responses, average_score)
    morph "#summary_#{question.id}", render(partial: "shared/surveys/summary", locals: { message: message, color: color })
  end

  private

  def question
    @question ||= Survey::Question.find(element.dataset["question-id"])
  end

  def participant
    @participant ||= element.dataset["participant-type"].capitalize.constantize.find(element.dataset["participant-id"])
  end

  def fetch_stats
    Survey::Stats::SurveyParticipantStats.new(question.survey, participant, false).stats_for(question)
  end

  def color_message_for(total_responses, average_score)
    message = build_message(total_responses, average_score)
    color = score_color(average_score)
    [color, message]
  end

  def build_message(total_responses, average_score)
    if total_responses.positive?
      "Average score is #{average_score.round(2)} in #{total_responses} response(s) received from your team."
    else
      "No answer to this question yet from your team."
    end
  end

  def score_color(score)
    case score
    when 8.. then "bg-green-100"
    when 4...8 then "bg-yellow-100"
    else "bg-red-100"
    end
  end
end
