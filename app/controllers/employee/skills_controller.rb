class Employee::SkillsController < Employee::BaseController
  def index
    authorize [@employee, Skill]

    @skill = Skill.new
    @skills = @employee.skills.order("lower(name) asc")
  end
end
