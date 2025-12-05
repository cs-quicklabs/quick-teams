class AddCommentOnReport < Patterns::Service
  def initialize(params, report, method, actor)
    @comment = Comment.new(params)
    @report = report
    @employee = report.user
    @method = method
    @actor = actor
  end

  def call
    add_comment
    send_email
    comment
  rescue StandardError
    comment
  end

  private

  attr_reader :report, :comment, :method, :actor, :employee

  def add_comment
    comment.commentable = report
    comment.save!
  end

  def send_email
    return unless report.reportable_type == "User" && deliver_email?

    CommentsMailer.with(actor: actor, employee: employee, report: report)
                  .commented_email
                  .deliver_later
  end

  def deliver_email?
    actor != employee && employee.email_enabled && employee.account.email_enabled
  end
end
