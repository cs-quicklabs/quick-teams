class NuggetsController < ApplicationController
    before_action :set_project, only: %i[ update create destroy edit ]
  before_action :set_nugget, only: %i[ update destroy edit ]

  def index
    authorize :nuggets
    @nugget = Nugget.new
    nuggets = User.for_current_account.active.includes(:nuggets, :role).order(:first_name)
    @pagy, @nuggets = pagy_nil_safe(nuggets, items: 20)

        fresh_when @nuggets
     
  end

  def pagy_nil_safe(collection, vars = {})
    pagy = Pagy.new(count: collection.count(:all), page: params[:page], **vars)
    return pagy, collection.offset(pagy.offset).limit(pagy.items) if collection.respond_to?(:offset)
    return pagy, collection
  end
  def show
    authorize :nuggets

    redirect_to nuggets_path(current_user)
  end
  def update
    authorize :nuggets
  

    @nugget = Updatenugget.call(@nugget,  current_user, nugget_params).result

    respond_to do |format|
      if @nugget.errors.empty?
        render turbo_stream: turbo_stream.prepend("nuggets", partial: "nuggets/nugget", locals: { nugget: @nugget }) +
                             turbo_stream.replace(nugget.new, partial: "nuggets/form", locals: { nugget: nugget.new })
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@nugget, partial: "nuggets/form", locals: { nugget: @nugget }) }
      end
    end
 
  end

  def create
    authorize :nuggets

    nugget = Updatenugget.call(nugget.new,current_user, nugget_params).result

    respond_to do |format|
      if nugget.persisted?
        format.turbo_stream { redirect_to nuggets_path(@project), notice: "Participant was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(nugget.new, partial: "nugget/form", locals: { nugget: @nugget }) }
      end
    end
 
  end

  def edit
    authorize :nuggets
  end

  def destroy
    authorize :nuggets

    @nugget.destroy
    respond_to do |format|
      format.turbo_stream { redirect_to nuggets_path(@nugget), notice: "nugget was removed successfully." }
    end
  end

  private

  def set_user
    @user ||= User.find(params["user_id"])
  end

  def set_nugget
    @nugget ||= nugget.find(params["id"])
  end

  def nugget_params
    params.require(:nugget).permit(:user_id, :title, :skill_id, :description, :published_on)
  end

end
