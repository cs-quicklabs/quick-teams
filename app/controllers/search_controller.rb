class SearchController < ApplicationController
  def search
    like_keyword = "%#{params[:q]}%"
    @employees = User.for_current_account.where("first_name ILIKE ?", like_keyword).limit(3)
    @projects = Project.active.where("name ILIKE ?", like_keyword).limit(3)

    render layout: false
  end
end
