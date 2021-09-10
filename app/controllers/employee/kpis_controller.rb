class Employee::KpisController < Employee::BaseController
  def index
    authorize [@employee, :kpi]
    @kpi = Survey::Survey.first
  end
end
