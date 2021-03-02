class Account::SkillsController < Account::BaseController
  before_action :set_skill, only: %i[ show edit update destroy ]

  # GET /skills or /skills.json
  def index
    @skills = Skill.all
    @skill = Skill.new
  end

  # GET /skills/1 or /skills/1.json
  def show
  end

  # GET /skills/new
  def new
    @skill = Skill.new
  end

  # GET /skills/1/edit
  def edit
  end

  # POST /skills or /skills.json
  def create
    @skill = Skill.new(skill_params)

    respond_to do |format|
      if @skill.save
        @skill = Skill.new
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Skill.new, partial: "skills/form", locals: { message: "Skill was created successfully." }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Skill.new, partial: "skills/form", locals: {}) }
      end
    end
  end

  # PATCH/PUT /skills/1 or /skills/1.json
  def update
    respond_to do |format|
      if @skill.update(skill_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@skill, partial: "skills/skill", locals: { message: "Skill was created successfully.", skill: @skill }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@skill, partial: "skills/skill", locals: { skill: @skill }) }
      end
    end
  end

  # DELETE /skills/1 or /skills/1.json
  def destroy
    @skill.destroy
    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_skill
    @skill = Skill.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def skill_params
    params.require(:skill).permit(:name, :account_id)
  end
end
