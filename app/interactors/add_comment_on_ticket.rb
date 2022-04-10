class AddCommentOnTicket < Patterns::Service
  def initialize(params, ticket, method, actor)
    @comment = Comment.new(params)
    @ticket = ticket

    @method = method
    @actor = actor
    if (actor == ticket.user or actor.admin?)
      @employee = ticket.ticket_label.user
    else
      @employee = ticket.user
    end
  end

  def call
    begin
      add_comment
      update_ticket
      send_email
    rescue
      comment
    end
    comment
  end

  private

  def add_comment
    comment.commentable = ticket
    comment.save!
  end

  def update_ticket
    if method == "and mark Closed"
      ticket.update_attribute("ticketstatus", true)
    end
  end

  def send_email
    CommentsMailer.with(actor: actor, employee: employee, ticket: ticket).commented_ticket.deliver_later if deliver_email?
  end

  def deliver_email?
    (actor != employee) and employee.email_enabled and employee.account.email_enabled
  end

  attr_reader :ticket, :comment, :method, :actor, :employee
end
