class Project::SkillsController < Project::BaseController
  def index
    authorize @project

    @skill = Skill.new
    @skills = @project.skills
  end
end
