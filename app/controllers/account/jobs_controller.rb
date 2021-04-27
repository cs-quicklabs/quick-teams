class Account::JobsController < Account::BaseController
  before_action :set_job, only: %i[ show edit update destroy ]

  def index
    authorize :account
    @jobs = Job.all.order(created_at: :desc)
    @job = Job.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @job = Job.new(job_params)
    respond_to do |format|
      if @job.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:jobs, partial: "account/jobs/job", locals: { job: @job }) +
                               turbo_stream.replace(Job.new, partial: "account/jobs/form", locals: { job: Job.new, message: "Job was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Job.new, partial: "account/jobs/form", locals: { job: @job }) }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @job.update(job_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@job, partial: "account/jobs/job", locals: { job: @job, messages: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@job, template: "account/jobs/edit", locals: { job: @job, messages: @job.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @job.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@job) }
    end
  end

  private

  def set_job
    @job ||= Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:name, :account_id)
  end
end
