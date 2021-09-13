class SurveyStatsReflex < ApplicationReflex
  def summary
    question = Survey::Question.find(element.dataset["question-id"])
    total_responses, average_score = Survey::Stats::SurveyStats.new(question.survey).stats_for(question)
    color, message = color_message_for(total_responses, average_score)
    morph "#summary_#{question.id}", render(partial: "shared/surveys/summary", locals: { message: message, color: color })
  end

  def color_message_for(total_responses, average_score)
    color = "bg-gray-50"
    message = "No answer to this question yet."
    if total_responses > 0
      message = "Average score is #{average_score.round(1)} in #{total_responses} responses."
    end

    if average_score >= 8
      color = "bg-green-50"
    elsif average_score >= 4
      color = "bg-yellow-50"
    else
      color = "bg-red-50"
    end
    return color, message
  end
end
