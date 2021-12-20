class AddCommentOnReport < Patterns::Service
  def initialize(params, report, actor)
    @comment = Comment.new(params)
    @report = report
    @employee = @report.reportable
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
    comment.commentable = report
    comment.status = 1
    comment.save!
  end

  def send_email
    return unless report.reportable_type == "User"
    CommentsMailer.with(actor: actor, employee: employee, report: report).commented_email.deliver_later if deliver_email?
  end

  def deliver_email?
    (actor != employee) and employee.email_enabled and employee.account.email_enabled
  end

  attr_reader :report, :comment, :method, :actor, :employee
end
