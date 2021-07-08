class Employee::SkillsController < Employee::BaseController
  def index
    authorize @employee, :show_skills?

    @skill = Skill.new
    @skills = @employee.skills
  end
end
