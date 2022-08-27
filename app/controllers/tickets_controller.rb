class TicketsController < BaseController
  before_action :set_ticket, only: %i[ update destroy edit show comment change_status ]

  def index
    authorize :ticket
    @ticket = Ticket.new
    tickets = current_user.tickets.includes(:ticket_label, :ticket_status, :user).order(created_at: :desc)
    @pagy, @tickets = pagy_nil_safe(params, tickets, items: 20)
    render_partial("tickets/ticket", collection: @tickets, cached: true) if stale?(@tickets)
  end

  def new
    authorize :ticket
    @ticket = Ticket.new
  end

  def show
    authorize [@ticket]
    @statuses = TicketStatus.all - [@ticket.ticket_status]
    @status_count = (@statuses.pluck(:id) - [@ticket.ticket_status_id]).count
    @comment = Comment.new
    fresh_when [@ticket] + @ticket.comments
  end

  def change_status
    authorize @ticket
  end

  def open
    authorize :ticket

    tickets = policy_scope(Ticket)
    @pagy, @tickets = pagy_nil_safe(params, tickets, items: 20)
    render_partial("tickets/ticket", collection: @tickets, cached: true) if stale?(@tickets)
  end

  def update
    authorize [@ticket]

    respond_to do |format|
      if @ticket.update(ticket_params)
        format.turbo_stream { redirect_to ticket_path(@ticket), notice: "Ticket was updated successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@ticket, partial: "tickets/form", locals: { ticket: @ticket, title: "Edit Ticket" }) }
      end
    end
  end

  def create
    authorize :ticket
    @ticket = AddTicket.call(ticket_params, current_user).result
    respond_to do |format|
      if @ticket.errors.empty?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:tickets, partial: "tickets/ticket", locals: { ticket: @ticket }) +
                               turbo_stream.replace(Ticket.new, partial: "tickets/form", locals: { ticket: Ticket.new, message: "Ticket was created successfully.", title: "Add New Ticket", subtitle: "You can raise a ticket if you need anything to get your work done. The types of tickets are defined by admin." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Ticket.new, partial: "tickets/form", locals: { ticket: @ticket, title: "Add New Ticket", subtitle: "You can raise a ticket if you need anything to get your work done. The types of tickets are defined by admin" }) }
      end
    end
  end

  def edit
    authorize [@ticket]
  end

  def destroy
    authorize [@ticket]
    @ticket.destroy
    respond_to do |format|
      format.turbo_stream { redirect_to tickets_path, status: 303, notice: "Ticket was removed successfully." }
    end
  end

  def comment
    authorize [@ticket]

    @comment = AddCommentOnTicket.call(comment_params, @ticket, params[:commit], current_user).result
    respond_to do |format|
      if @comment.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.append(:comments, partial: "shared/comments/comment", locals: { comment: @comment }) +
                               turbo_stream.replace("comment", partial: "shared/comments/ticket", locals: { ticket: @ticket, comment: Comment.new }) +
                               turbo_stream.replace("title", partial: "tickets/title", locals: { ticket: @ticket })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:add, partial: "shared/comments/ticket", locals: { ticket: @ticket, comment: @comment }) }
      end
    end
  end

  private

  def set_ticket
    @ticket ||= Ticket.find_by(id: params["id"])
  end

  def ticket_params
    params.require(:ticket).permit(:ticket_label_id, :title, :description, :user_id, :account_id)
  end

  def comment_params
    params.require(:comment).permit(:title, :user_id, :commentable_id, :status)
  end
end
