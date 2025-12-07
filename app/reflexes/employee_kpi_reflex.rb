class EmployeeKpiReflex < ApplicationReflex
  def assessment
    morph "#modal", render(partial: "shared/assessment", locals: {
                       question: question,
                       participant: participant,
                       actor: actor,
                       attempt: Survey::Attempt.new,
                       main_button_visible: true,
                     })
  end

  def self_assessment
    render_assessment_stats(show_own_attempts: true)
  end

  def team_assessment
    render_assessment_stats(show_own_attempts: false)
  end

  def view_comment
    attempt = Survey::Attempt.find(element.dataset[:comment])
    morph "#modal", render(partial: "shared/comment", locals: { attempt: attempt, main_button_visible: true })
  end

  private

  def question
    @question ||= Survey::Question.find(element.dataset[:question_id])
  end

  def participant
    @participant ||= User.find(element.dataset[:participant_id])
  end

  def actor
    @actor ||= User.find(element.dataset[:actor_id])
  end

  def employee
    @employee ||= User.find(element.dataset[:employee_id])
  end

  def render_assessment_stats(show_own_attempts:)
    kpi = employee.kpi
    stats = Survey::Stats::KpiStats.get_stats(kpi, employee, show_own_attempts) if kpi.present?

    morph "#stats", render(partial: "shared/surveys/kpi_stats", locals: {
                       employee: employee,
                       kpi: kpi,
                       stats: stats,
                       show_own_attempts: show_own_attempts,
                     })
  end
end
