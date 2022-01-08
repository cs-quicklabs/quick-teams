class EmployeeKpiReflex < ApplicationReflex
  def assessment
    question = Survey::Question.find(element.dataset[:question_id])
    participant = User.find(element.dataset[:participant_id])
    actor = User.find(element.dataset[:actor_id])
    attempt = Survey::Attempt.new
    morph "#modal", render(partial: "shared/assessment", locals: { question: question, participant: participant, actor: actor, attempt: attempt, main_button_visible: true })
  end

  def self_assessment
    employee = User.find(element.dataset[:employee_id])
    kpi = employee.kpi
    show_own_attempts = true
    unless kpi.nil?
      stats = Survey::Stats::KpiStats.get_stats(kpi, employee, show_own_attempts)
    end

    morph "#stats", render(partial: "shared/surveys/kpi_stats", locals: { employee: employee, kpi: kpi, stats: stats, show_own_attempts: show_own_attempts })
  end

  def team_assessment
    employee = User.find(element.dataset[:employee_id])
    kpi = employee.kpi
    show_own_attempts = false
    unless kpi.nil?
      stats = Survey::Stats::KpiStats.get_stats(kpi, employee, show_own_attempts)
    end

    morph "#stats", render(partial: "shared/surveys/kpi_stats", locals: { employee: employee, kpi: kpi, stats: stats, show_own_attempts: show_own_attempts })
  end
end
