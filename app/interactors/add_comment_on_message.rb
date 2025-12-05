class AddCommentOnMessage < Patterns::Service
  def initialize(params, message, actor)
    @comment = MessageComment.new(params)
    @message = Message.find(message)
    @actor = User.find(actor)
  end

  def call
    add_comment
    send_emails
    comment
  rescue StandardError
    comment
  end

  private

  attr_reader :message, :comment, :actor

  def add_comment
    comment.save!
  end

  def send_emails
    recipients.each do |user|
      CommentMailer.with(employee: user, comment: comment, actor: actor, message: message, space: message.space)
                   .comment_email
                   .deliver_later
    end
  end

  def recipients
    (message.space.users - [actor]).select { |user| deliver_email?(user) }
  end

  def deliver_email?(employee)
    actor != employee && employee.email_enabled && employee.account.email_enabled
  end
end
