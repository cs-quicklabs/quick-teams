class SearchController < BaseController
  def search
    authorize :team, :index?

    like_keyword = "%#{params[:q]}%"
    @employees = User.for_current_account.active.where("first_name ILIKE ?", like_keyword).limit(3).order(:first_name)
    @projects = Project.active.where("name ILIKE ?", like_keyword).limit(3).order(:name)

    render layout: false
  end
end
