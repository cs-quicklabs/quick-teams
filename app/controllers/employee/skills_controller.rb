class Employee::SkillsController < Employee::BaseController
  def index
    authorize @employee, :show_skills?

    @skill = Skill.new
    @skills = ["ios", "android", "AWS", "Storyboarding", "Design", "Photoshop", "Music Production", "TDD", "Code Igniter", "Sinatra", "React"]
  end
end
