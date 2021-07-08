class SearchController < BaseController
  def people_projects
    authorize :team, :index?

    like_keyword = "%#{params[:q]}%"
    @employees = User.for_current_account.active.where("first_name ILIKE ?", like_keyword).includes(:job)
      .or(User.for_current_account.active.where("last_name ILIKE ?", like_keyword).includes(:job))
      .limit(3).order(:first_name)
    @projects = Project.active.where("name ILIKE ?", like_keyword).limit(3).order(:name)

    render layout: false
  end

  def skills
    authorize :team, :index?

    like_keyword = "%#{params[:q]}%"
    @employee = User.find(params[:id])
    @skills = Skill.where("name ILIKE ?", like_keyword)
      .limit(3).order(:name) - @employee.skills

    render layout: false
  end
end
