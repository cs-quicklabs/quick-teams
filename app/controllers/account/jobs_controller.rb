class Account::JobsController < Account::BaseController
  before_action :set_job, only: %i[ show edit update destroy ]

  # GET /jobs or /jobs.json
  def index
    @jobs = Job.all
    @job = Job.new
  end

  # GET /jobs/1 or /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs or /jobs.json
  def create
    @job = Job.new(job_params)

    respond_to do |format|
      if @job.save
        @job = Job.new
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Job.new, partial: "jobs/form", locals: { message: "Job was created successfully." }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Job.new, partial: "jobs/form", locals: {}) }
      end
    end
  end

  # PATCH/PUT /jobs/1 or /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@job, partial: "jobs/job", locals: { message: "Job was created successfully.", job: @job }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@job, partial: "jobs/job", locals: { job: @job }) }
      end
    end
  end

  # DELETE /jobs/1 or /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_job
    @job = Job.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def job_params
    params.require(:job).permit(:name, :account_id)
  end
end
