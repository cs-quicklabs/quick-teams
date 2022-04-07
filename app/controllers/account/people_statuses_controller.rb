class Account::PeopleStatusesController < Account::BaseController
  before_action :set_people_status, only: %i[ show edit update destroy ]

  def index
    authorize :account

    @people_statuses = PeopleStatus.all.order(:name).order(created_at: :desc)
    @people_status = PeopleStatus.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @people_status = PeopleStatus.new(people_status_params)

    respond_to do |format|
      if @people_status.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:people_statuses, partial: "account/people_statuses/people_status", locals: { people_status: @people_status }) +
                               turbo_stream.replace(PeopleStatus.new, partial: "account/people_statuses/form", locals: { people_status: PeopleStatus.new, message: "People Status was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(PeopleStatus.new, partial: "account/people_statuses/form", locals: { people_status: @people_status }) }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @people_status.update(people_status_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@people_status, partial: "account/people_statuses/people_status", locals: { people_status: @people_status, message: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@people_status, template: "account/people_statuses/edit", locals: { people_status: @people_status, messages: @people_status.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @people_status.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@people_status) }
    end
  end

  private

  def set_people_status
    @people_status ||= PeopleStatus.find(params[:id])
  end

  def people_status_params
    params.require(:people_status).permit(:name, :account_id, :color)
  end
end
