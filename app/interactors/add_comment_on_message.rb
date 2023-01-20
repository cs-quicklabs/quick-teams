class AddCommentOnMessage < Patterns::Service
  def initialize(params, message, actor)
    @params = params
    @comment = Comment.new(params)
    @message = message
    @employee = message.user_id
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
    comment.title = params[:body]
    comment.commentable = message
    comment.save!
  end

  def send_email
    return unless message.messageable_type == "User" and deliver_email?
  end

  def deliver_email?
    (actor != employee) and employee.email_enabled and employee.account.email_enabled
  end

  attr_reader :message, :comment, :actor, :employee, :params
end
