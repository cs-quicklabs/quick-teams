class Employee::SkillsController < Employee::BaseController
  def index
    authorize [@employee, Skill]

    @skill = Skill.new
    @skills = @employee.skills
  end
end
