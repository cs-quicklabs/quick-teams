class SearchController < ApplicationController
  before_action :force_json, only: :search

  def search
    like_keyword = "%#{params[:q]}%"

    @projects = Project.where("name ILIKE ?", like_keyword).limit(3)
    @employees = User.for_current_account.where("first_name ILIKE ?", like_keyword).limit(3)
  end

  private

  def force_json
    request.format = :json
  end
end
