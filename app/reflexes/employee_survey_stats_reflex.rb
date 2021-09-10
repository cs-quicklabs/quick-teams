class EmployeeSurveyStatsReflex < ApplicationReflex
  def summary
    question = Survey::Question.find(element.dataset["question-id"])
    survey = question.survey
    employee = User.find(element.dataset["employee-id"])
    attempts = survey.attempts.where(participant: employee)
    answers = attempts.map(&:answers).flatten.compact
    total_responses = answers.count
    color = "bg-gray-50"
    if total_responses == 0
      message = "No answer to this question yet."
    else
      average_score = answers.map(&:score).sum / total_responses
      message = "Average score is #{average_score} in #{total_responses} responses."
    end

    morph "#summary_#{question.id}", render(partial: "employee/kpis/summary", locals: { message: message, color: color })
  end
end
