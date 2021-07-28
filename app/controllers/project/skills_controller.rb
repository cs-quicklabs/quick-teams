class Project::SkillsController < Project::BaseController
  def index
    authorize [@project, Skill]

    @skill = Skill.new
    @skills = @project.skills.order("lower(name) asc")
  

  end
end
