class Employee::SkillsController < Employee::BaseController
  before_action :set_employee, only: %i[show_skills]

  def index
    authorize [@employee, Skill]

    @skill = Skill.new
    @skills = @employee.skills.order("lower(name) asc")
  end

  def show_skills
    authorize [@employee, Skill]
    @skills = @employee.skills.order("lower(name) asc")
  end
end
