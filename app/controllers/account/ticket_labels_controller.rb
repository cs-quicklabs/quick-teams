class Account::TicketLabelsController < Account::BaseController
  before_action :set_ticket_label, only: %i[ show edit update destroy ]

  def index
    authorize :account

    @ticket_labels = TicketLabel.all.includes(:user, :discipline).order(:name).order(created_at: :desc)
    @ticket_label = TicketLabel.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @ticket_label = TicketLabel.new(ticket_label_params)

    respond_to do |format|
      if @ticket_label.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:ticket_labels, partial: "account/ticket_labels/ticket_label", locals: { ticket_label: @ticket_label }) +
                               turbo_stream.replace(TicketLabel.new, partial: "account/ticket_labels/form", locals: { ticket_label: TicketLabel.new, message: "Ticket label was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(TicketLabel.new, partial: "account/ticket_labels/form", locals: { ticket_label: @ticket_label }) }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @ticket_label.update(ticket_label_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@ticket_label, partial: "account/ticket_labels/ticket_label", locals: { ticket_label: @ticket_label, message: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@ticket_label, template: "account/ticket_labels/edit", locals: { ticket_label: @ticket_label, messages: @ticket_label.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @ticket_label.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@ticket_label) }
    end
  end

  private

  def set_ticket_label
    @ticket_label ||= TicketLabel.find(params[:id])
  end

  def ticket_label_params
    params.require(:ticket_label).permit(:account_id, :discipline_id, :name, :user_id)
  end
end
