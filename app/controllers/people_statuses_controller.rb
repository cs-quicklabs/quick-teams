class PeopleStatusesController < ApplicationController
  before_action :set_people_status, only: %i[ show edit update destroy ]

  # GET /people_statuses or /people_statuses.json
  def index
    @people_statuses = PeopleStatus.all
    @people_status = PeopleStatus.new
  end

  # GET /people_statuses/1 or /people_statuses/1.json
  def show
  end

  # GET /people_statuses/new
  def new
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
        @people_status = PeopleStatus.new
        format.turbo_stream { render turbo_stream: turbo_stream.replace(PeopleStatus.new, partial: "people_statuses/form", locals: { message: "People Status was created successfully." }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(PeopleStatus.new, partial: "people_statuses/form", locals: {}) }
      end
    end
  end

  # PATCH/PUT /people_statuses/1 or /people_statuses/1.json
  def update
    respond_to do |format|
      if @people_status.update(people_status_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@people_status, partial: "people_statuses/people_status", locals: { message: "People Status was created successfully.", people_status: @people_status }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@people_status, partial: "people_statuses/people_status", locals: { people_status: @people_status }) }
      end
    end
  end

  # DELETE /people_statuses/1 or /people_statuses/1.json
  def destroy
    @people_status.destroy
    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
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
