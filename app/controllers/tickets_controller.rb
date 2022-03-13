class TicketsController < BaseController
  before_action :set_ticket, only: %i[ update destroy edit show comment ]

  def index
    authorize :ticket
    @ticket = Ticket.new
    tickets = Ticket.all
    @pagy, @tickets = pagy_nil_safe(params, tickets, items: 20)
    render_partial("tickets/ticket", collection: @tickets, cached: true) if stale?(@tickets)
  end

  def new
    authorize :ticket
    @ticket = Ticket.new
  end

  def show
    authorize @ticket
  end

  def update
    authorize [@ticket]

    respond_to do |format|
      if @ticket.update(ticket_params)
        format.turbo_stream { redirect_to ticket_path(@ticket), notice: "ticket was updated successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@ticket, partial: "tickets/form", locals: { ticket: @ticket, title: "Edit ticket" }) }
      end
    end
  end

  def create
    authorize :ticket
    @ticket = Ticket.create(ticket_params)
    respond_to do |format|
      if @ticket.errors.empty?
        format.turbo_stream { redirect_to ticket_path(@ticket), notice: "Ticket was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Ticket.new, partial: "tickets/form", locals: { ticket: @ticket, title: "Add New Ticket" }) }
      end
    end
  end

  def labels
    authorize Ticket
    @target = params[:target]
    @labels = TicketLabel.where(discipline_id: params[:discipline_id])
    respond_to do |format|
      format.turbo_stream
    end
  end

  def edit
    authorize [@ticket]
  end

  def destroy
    authorize @ticket
    @ticket.destroy
    respond_to do |format|
      format.turbo_stream { redirect_to tickets_path, status: 303, notice: "ticket was removed successfully." }
    end
  end

  def comment
    authorize [@ticket]

    @comment = AddCommentOnTicket.call(comment_params, @ticket, params[:commit], current_user).result
    respond_to do |format|
      if @comment.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.append(:comments, partial: "shared/comments/comment", locals: { comment: @comment }) +
                               turbo_stream.replace("comment", partial: "shared/comments/ticket", locals: { ticket: @ticket, comment: Comment.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:add, partial: "shared/comments/ticket", locals: { ticket: @ticket, comment: @comment }) }
      end
    end
  end

  private

  def set_ticket
    @ticket ||= Ticket.find(params["id"])
  end

  def ticket_params
    params.require(:ticket).permit(:ticket_label_id, :title, :description, :user_id, :account_id, :discipline_id, :ticket_status_id)
  end

  def comment_params
    params.require(:comment).permit(:title, :user_id, :commentable_id, :status)
  end
end
