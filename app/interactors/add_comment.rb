class AddComment < Patterns::Service
  def initialize(params, commentable, method, actor)
    @comment = Comment.new(params)
    @goal = goal
    if params[:commentable_type] == "Goal"
      @employee = commentable.goalable
      @goal = commentable
    else
      @employee = commentable.reportable
    end
    @method = method
    @actor = actor
  end

  def call
    begin
      add_comment
      update_goal
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

  def update_goal
    if comment.commentable_type == "Goal"
      if method == "Comment"
      elsif method == "and mark Missed"
        goal.update_attribute("status", "missed")
      elsif method == "and mark Completed"
        goal.update_attribute("status", "completed")
      elsif method == "and mark Discarded"
        goal.update_attribute("status", "discarded")
      end
    end
  end

  def send_email
    if comment.commentable_type == "Goal"
      return unless goal.goalable_type == "User" and deliver_email?

      if method == "Comment"
        GoalsMailer.with(actor: actor, employee: employee, goal: goal).commented_email.deliver_later
      elsif method == "and mark Missed"
        GoalsMailer.with(actor: actor, employee: employee, goal: goal).missed_email.deliver_later
      elsif method == "and mark Completed"
        GoalsMailer.with(actor: actor, employee: employee, goal: goal).completed_email.deliver_later
      elsif method == "and mark Discarded"
        GoalsMailer.with(actor: actor, employee: employee, goal: goal).discarded_email.deliver_later
      end
    end
  end

  def deliver_email?
    (actor != employee) and employee.email_enabled and employee.account.email_enabled
  end

  attr_reader :goal, :comment, :method, :actor, :employee
end
