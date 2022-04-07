class Account::TicketStatusesController < Account::BaseController
  before_action :set_ticket_status, only: %i[ show edit update destroy ]

  def index
    authorize :account

    @ticket_statuses = TicketStatus.all.order(:name).order(created_at: :desc)
    @ticket_status = TicketStatus.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @ticket_status = TicketStatus.new(ticket_status_params)

    respond_to do |format|
      if @ticket_status.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:ticket_statuses, partial: "account/ticket_statuses/ticket_status", locals: { ticket_status: @ticket_status }) +
                               turbo_stream.replace(TicketStatus.new, partial: "account/ticket_statuses/form", locals: { ticket_status: TicketStatus.new, message: "Ticket status was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(TicketStatus.new, partial: "account/ticket_statuses/form", locals: { ticket_status: @ticket_status }) }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @ticket_status.update(ticket_status_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@ticket_status, partial: "account/ticket_statuses/ticket_status", locals: { ticket_status: @ticket_status, message: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@ticket_status, template: "account/ticket_statuses/edit", locals: { ticket_status: @ticket_status, messages: @ticket_status.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @ticket_status.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@ticket_status) }
    end
  end

  private

  def set_ticket_status
    @ticket_status ||= TicketStatus.find(params[:id])
  end

  def ticket_status_params
    params.require(:ticket_status).permit(:name, :account_id, :color)
  end
end
