class AddCommentOnMessage < Patterns::Service
  def initialize(params, message, actor)
    @comment = MessageComment.new(params)
    @message = message
    @actor = actor
  end

  def call
    begin
      add_comment
      send_email
    rescue
      comment
    end
    comment
  end

  private

  def add_comment
    comment.save!
  end

  def send_email
    (message.space.users - actor).each do |user|
      return unless deliver_email?
      CommentMailer.with(employee: user, comment: comment, actor: actor).comment_email.deliver_later
    end
  end

  def deliver_email?
    (actor != employee) and employee.email_enabled and employee.account.email_enabled
  end

  attr_reader :message, :comment, :actor
end
