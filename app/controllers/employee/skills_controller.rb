class Employee::SkillsController < Employee::BaseController
  before_action :set_user, only: %i[show_skills, add_skill]

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

  def add_skill
    authorize [@employee, Skill]
    @skill = Skill.find(params["id"])

    if @employee.skills.include? @skill
      @employee.skills.destroy @skill
    else
      @employee.skills << @skill
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@skill, partial: "employee/skills/skill", locals: { employee: @employee, skill: @skill, selected: @employee.skills.include?(@skill) })
      end
    end
  end

  private

  def set_user
    @employee = User.find(params["employee_id"])
  end
end
