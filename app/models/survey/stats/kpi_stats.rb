class Survey::Stats::KpiStats < Survey::Stats::SurveyStats
  def self.get_stats(kpi, employee, show_own_attempts)
    consider_overall_kpi_score = Preference.where(account: employee.account, key: "consider_overall_kpi_score").first.value == "true"
    if consider_overall_kpi_score
      Survey::Stats::EmployeeKpiStats.new(kpi, employee, show_own_attempts)
    else
      Survey::Stats::SurveyParticipantStats.new(kpi, employee, show_own_attempts)
    end
  end
end
