class SearchController < BaseController
  def people_projects
    authorize :search

    like_keyword = "%#{params[:q]}%"
    @employees = User.for_current_account.active.where("first_name ILIKE ?", like_keyword).includes(:job)
      .or(User.for_current_account.active.where("last_name ILIKE ?", like_keyword).includes(:job))
      .limit(3).order(:first_name)
    @projects = Project.active.where("name ILIKE ?", like_keyword).limit(3).order(:name)

    render layout: false
  end

  def employee_skills
    authorize :search

    like_keyword = "%#{params[:q]}%"
    @employee = User.find(params[:id])
    @skills = Skill.where("name ILIKE ?", like_keyword)
      .limit(3).order(:name) - @employee.skills

    render layout: false
  end

  def project_skills
    authorize :search

    like_keyword = "%#{params[:q]}%"
    @project = Project.find(params[:id])
    @skills = Skill.where("name ILIKE ?", like_keyword)
      .limit(5).order(:name) - @project.skills

    render layout: false
  end

  def documents
    authorize :search

    # like_keyword = "%#{params[:q]}%"
    # @kbs = Kb.where("document ILIKE ?", like_keyword)
    #   .limit(5).order(:document)

    @kbs = Kb.search_title(params[:q])
    render layout: false
  end
    def surveys
    like_keyword = "%#{params[:q]}%"
    @surveys = Survey::Survey.where("name ILIKE ?", like_keyword)
      .limit(10).order(:name)

    render layout: false
  end
end
