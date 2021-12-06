class AddReportComment < Patterns::Service
  def initialize(params, report, method, actor)
    @comment = Comment.new(params)
    @report = report
    @employee = report.reportable
    @method = method
    @actor = actor
  end

  def call
    add_comment
    send_email
    begin
    rescue
      comment
    end
    comment
  end

  private

  def add_comment
    comment.user_id = actor.id
    comment.commentable = report
    comment.save!
  end

  def send_email
    return unless report.reportable_type == "User" and deliver_email?

    CommentsMailer.with(actor: actor, employee: employee, report: report).commented_email if deliver_email?
  end

  def deliver_email?
    (actor != employee) and employee.email_enabled and employee.account.email_enabled
  end

  attr_reader :report, :comment, :method, :actor, :employee
end
