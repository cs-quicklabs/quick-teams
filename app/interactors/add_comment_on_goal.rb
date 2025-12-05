class AddCommentOnGoal < Patterns::Service
  STATUS_MAP = {
    "and mark Missed" => "missed",
    "and mark Completed" => "completed",
    "and mark Discarded" => "discarded",
  }.freeze

  EMAIL_METHOD_MAP = {
    "Comment" => :commented_email,
    "and mark Missed" => :missed_email,
    "and mark Completed" => :completed_email,
    "and mark Discarded" => :discarded_email,
  }.freeze

  def initialize(params, goal, method, actor)
    @comment = Comment.new(params)
    @goal = goal
    @employee = goal.goalable
    @method = method
    @actor = actor
  end

  def call
    add_comment
    update_goal_status
    send_email
    comment
  rescue StandardError
    comment
  end

  private

  attr_reader :goal, :comment, :method, :actor, :employee

  def add_comment
    comment.commentable = goal
    comment.save!
  end

  def update_goal_status
    return unless STATUS_MAP.key?(method)

    goal.update!(status: STATUS_MAP[method])
  end

  def send_email
    return unless goal.goalable_type == "User" && deliver_email?

    email_method = EMAIL_METHOD_MAP[method]
    return unless email_method

    GoalsMailer.with(actor: actor, employee: employee, goal: goal)
               .public_send(email_method)
               .deliver_later
  end

  def deliver_email?
    actor != employee && employee.email_enabled && employee.account.email_enabled
  end
end
