class EmployeeSurveyStatsReflex < ApplicationReflex
  def summary
    question = Survey::Question.find(element.dataset["question-id"])
    employee = User.find(element.dataset["employee-id"])
    total_responses, average_score = employee_question_stats(question, employee)
    color, message = color_message_for(total_responses, average_score)

    morph "#summary_#{question.id}", render(partial: "employee/kpis/summary", locals: { message: message, color: color })
  end

  def employee_question_stats(question, employee)
    survey = question.survey
    attempts = survey.attempts.where(participant_id: employee.id, participant_type: "User")
    answers = Survey::Answer.where(attempt_id: attempts.ids, question: question)
    total_responses = answers.count
    average_score = 0.0
    if total_responses > 0
      average_score = answers.map(&:score).sum.to_f / total_responses
    end
    return total_responses, average_score
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
