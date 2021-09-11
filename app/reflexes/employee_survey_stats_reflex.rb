class EmployeeSurveyStatsReflex < ApplicationReflex
  def summary
    question = Survey::Question.find(element.dataset["question-id"])
    survey = question.survey
    employee = User.find(element.dataset["employee-id"])
    attempts = survey.attempts.where(participant: employee)
    answers = Survey::Answer.where(attempt_id: attempts.ids, question: question)
    total_responses = answers.count
    color = "bg-gray-50"
    average_score = 0.0
    message = ""
    if total_responses == 0
      message = "No answer to this question yet."
    else
      average_score = answers.map(&:score).sum.to_f / total_responses
      message = "Average score is #{average_score.round(1)} in #{total_responses} responses."
    end

    if average_score >= 0.8
      color = "bg-green-50"
    elsif average_score >= 0.4
      color = "bg-yellow-50"
    else
      color = "bg-red-50"
    end
    morph "#summary_#{question.id}", render(partial: "employee/kpis/summary", locals: { message: message, color: color })
  end
end
