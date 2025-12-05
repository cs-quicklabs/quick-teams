class AddCommentOnTicket < Patterns::Service
  def initialize(params, ticket, method, actor)
    @comment = Comment.new(params)
    @ticket = ticket
    @method = method
    @actor = actor
    @employee = determine_employee
  end

  def call
    add_comment
    update_ticket
    send_email
    comment
  rescue StandardError
    comment
  end

  private

  attr_reader :ticket, :comment, :method, :actor, :employee

  def determine_employee
    if actor == ticket.user || actor.admin?
      ticket.ticket_label.user
    else
      ticket.user
    end
  end

  def add_comment
    comment.commentable = ticket
    comment.save!
  end

  def update_ticket
    return unless method == "and mark closed"

    ticket.update!(ticketstatus: true)
  end

  def send_email
    return unless deliver_email?

    CommentsMailer.with(actor: actor, employee: employee, ticket: ticket)
                  .commented_ticket
                  .deliver_later
  end

  def deliver_email?
    actor != employee && employee.email_enabled && employee.account.email_enabled
  end
end
