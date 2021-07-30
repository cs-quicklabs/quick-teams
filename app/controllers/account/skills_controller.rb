class Account::SkillsController < Account::BaseController
  before_action :set_skill, only: %i[ show edit update destroy ]

  def index
    authorize :account

    @skills = Skill.all.order("lower(name) ASC")
    @skill = Skill.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @skill = Skill.new(skill_params)

    respond_to do |format|
      if @skill.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:skills, partial: "account/skills/skill", locals: { skill: @skill }) +
                               turbo_stream.replace(Skill.new, partial: "account/skills/form", locals: { skill: Skill.new, message: "Skill was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Skill.new, partial: "account/skills/form", locals: { skill: @skill }) }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @skill.update(skill_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@skill, partial: "account/skills/skill", locals: { skill: @skill, message: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@skill, template: "account/skills/edit", locals: { skill: @skill, messages: @skill.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @skill.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@skill) }
    end
  end

  private

  def set_skill
    @skill ||= Skill.find(params[:id])
  end

  def skill_params
    params.require(:skill).permit(:name, :account_id)
  end
end
