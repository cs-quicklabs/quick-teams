class Account::PeopleTagsController < Account::BaseController
  before_action :set_people_tag, only: %i[ show edit update destroy ]

  def index
    authorize :account

    @people_tags = PeopleTag.all.order(created_at: :desc)
    @people_tag = PeopleTag.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @people_tag = PeopleTag.new(people_tag_params)
    respond_to do |format|
      if @people_tag.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:people_tags, partial: "account/people_tags/people_tag", locals: { people_tag: @people_tag }) +
                               turbo_stream.replace(PeopleTag.new, partial: "account/people_tags/form", locals: { people_tag: PeopleTag.new, message: "Tag was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(PeopleTag.new, partial: "account/people_tags/form", locals: { people_tag: @people_tag }) }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @people_tag.update(people_tag_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@people_tag, partial: "account/people_tags/people_tag", locals: { people_tag: @people_tag, message: "nil" }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@people_tag, template: "account/people_tags/edit", locals: { people_tag: @people_tag, messages: @people_tag.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @people_tag.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@people_tag) }
    end
  end

  private

  def set_people_tag
    @people_tag ||= PeopleTag.find(params[:id])
  end

  def people_tag_params
    params.require(:people_tag).permit(:name, :account_id, :color)
  end
end
