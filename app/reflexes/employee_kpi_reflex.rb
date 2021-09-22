class EmployeeKpiReflex < ApplicationReflex
  def assessment
    question = Survey::Question.find(element.dataset[:question_id])
    participant = User.find(element.dataset[:participant_id])
    actor = User.find(element.dataset[:actor_id])
    attempt = Survey::Attempt.new
    morph "#modal", render(partial: "shared/assessment", locals: { question: question, participant: participant, actor: actor, attempt: attempt, main_button_visible: true })
  end
end
