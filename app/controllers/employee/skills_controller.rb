class Employee::SkillsController < Employee::BaseController
  before_action :set_user, only: %i[show_skills]

  def index
    authorize [@employee, Skill]

    @skill = Skill.new
    @skills = @employee.skills.order("lower(name) asc")
    fresh_when @skills + [@employee]
  end

  def show_skills
    authorize [User, Skill]
    @skills = Skill.order("lower(name) asc")
    @employee_skills = @employee.skills
  end

  private

  def set_user
    @employee = User.find(params["employee_id"]).decorate
  end
end
