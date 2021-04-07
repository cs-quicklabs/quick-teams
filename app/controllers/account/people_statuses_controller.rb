class Account::PeopleStatusesController < Account::BaseController
  before_action :set_people_status, only: %i[ show edit update destroy ]

  # GET /people_statuses or /people_statuses.json
  def index
    @people_statuses = PeopleStatus.all.order(created_at: :desc)
    @people_status = PeopleStatus.new
  end

  # GET /people_statuses/1/edit
  def edit
  end

  # POST /people_statuses or /people_statuses.json
  def create
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

  # PATCH/PUT /people_statuses/1 or /people_statuses/1.json
  def update
    respond_to do |format|
      if @people_status.update(people_status_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@people_status, partial: "account/people_statuses/people_status", locals: { people_status: @people_status, message: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@people_status, template: "account/people_statuses/edit", locals: { people_status: @people_status, messages: @people_status.errors.full_messages }) }
      end
    end
  end

  # DELETE /people_statuses/1 or /people_statuses/1.json
  def destroy
    @people_status.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@people_status) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_people_status
    @people_status = PeopleStatus.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def people_status_params
    params.require(:people_status).permit(:name, :account_id)
  end
end
