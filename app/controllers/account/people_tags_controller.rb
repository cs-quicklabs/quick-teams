class Account::PeopleTagsController < Account::BaseController
  before_action :set_people_tag, only: %i[ show edit update destroy ]

  # GET /people_tags or /people_tags.json
  def index
    @people_tags = PeopleTag.all
    @people_tag = PeopleTag.new
  end

  # GET /people_tags/1 or /people_tags/1.json
  def show
  end

  # GET /people_tags/new
  def new
    @people_tag = PeopleTag.new
  end

  # GET /people_tags/1/edit
  def edit
  end

  # POST /people_tags or /people_tags.json
  def create
    @people_tag = PeopleTag.new(people_tag_params)

    respond_to do |format|
      if @people_tag.save
        @people_tag = PeopleTag.new
        format.turbo_stream { render turbo_stream: turbo_stream.replace(PeopleTag.new, partial: "people_tags/form", locals: { message: "Tag was created successfully." }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(PeopleTag.new, partial: "people_tags/form", locals: {}) }
      end
    end
  end

  # PATCH/PUT /people_tags/1 or /people_tags/1.json
  def update
    respond_to do |format|
      if @people_tag.update(people_tag_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@people_tag, partial: "people_tags/people_tag", locals: { message: "Tag was created successfully.", people_tag: @people_tag }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@people_tag, partial: "people_tags/people_tag", locals: { people_tag: @people_tag }) }
      end
    end
  end

  # DELETE /people_tags/1 or /people_tags/1.json
  def destroy
    @people_tag.destroy
    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_people_tag
    @people_tag = PeopleTag.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def people_tag_params
    params.require(:people_tag).permit(:name, :account_id)
  end
end
