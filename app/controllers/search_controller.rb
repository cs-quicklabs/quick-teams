class SearchController < BaseController
  def people_projects
    authorize :search

    like_keyword = "%#{params[:q]}%".split(/\s+/)
    @employees = users_matching_name(like_keyword).take(3)
    @projects = projects_matching_name(like_keyword).take(3)
    @jobs = Job.where("name iLIKE ANY ( array[?] )", like_keyword).limit(3).order(:name)
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

    like_keyword = "%#{params[:q]}%"
    @kbs = Kb.where("document ILIKE ?", like_keyword)
      .limit(5).order(:document)

    render layout: false
  end

  def surveys
    authorize :search
    like_keyword = "%#{params[:q]}%"
    @surveys = Survey::Survey.where("name ILIKE ?", like_keyword)
      .limit(10).order(:name)
    render layout: false
  end

  def deactivated
    authorize :search

    like_keyword = "%#{params[:q]}%".split(/\s+/)
    @employees = User.for_current_account.inactive.where("first_name iLIKE ANY ( array[?] )", like_keyword).includes(:job)
      .or(User.for_current_account.inactive.where("last_name iLIKE ANY ( array[?] )", like_keyword).includes(:job))
      .order(:first_name).limit(4)
    render layout: false
  end

  def archived
    authorize :search
    like_keyword = "%#{params[:q]}%".split(/\s+/)
    @projects = Project.archived.where("name iLIKE ANY ( array[?] )", like_keyword).limit(4).order(:name)
    render layout: false
  end

  def users
    authorize :search
    like_keyword = "%#{params[:q]}%".split(/\s+/)
    @project = Project.find(params[:project_id])
    @employees = (users_matching_name(like_keyword) - @project.observers).take(6)

    render layout: false
  end

  def projects
    authorize :search
    like_keyword = "%#{params[:q]}%".split(/\s+/)
    @employee = User.find(params[:user_id])
    @projects = (projects_matching_name(like_keyword) - @employee.observed_projects).take(6)
    render layout: false
  end

  def users_matching_name(like_keyword)
    User.for_current_account.active.where("first_name iLIKE ANY ( array[?] )", like_keyword).includes(:job)
      .or(User.for_current_account.active.where("last_name iLIKE ANY ( array[?] )", like_keyword).includes(:job))
      .order(:first_name)
  end

  def projects_matching_name(like_keyword)
    Project.active.where("name iLIKE ANY ( array[?] )", like_keyword).order(:name)
  end
end
