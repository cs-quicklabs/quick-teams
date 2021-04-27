class CommentsController < BaseController
  def create
    authorize :comments

    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        @goal = update_goal
        format.turbo_stream {
          render turbo_stream: turbo_stream.append(:comments, partial: "employee/goals/comments/comment", locals: { comment: @comment }) +
                               turbo_stream.replace("add", partial: "employee/goals/comments/add", locals: { goal: @goal, comment: Comment.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:add, partial: "employee/goals/comments/add", locals: { goal: @goal, comment: @comment }) }
      end
    end
  end

  private

  def update_goal
    goal = Goal.find(comment_params["goal_id"])
    if params[:commit] == "Comment"
    elsif params[:commit] == "and mark Missed"
      goal.update(status: "missed")
    elsif params[:commit] == "and mark Completed"
      goal.update(status: "completed")
    elsif params[:commit] == "and mark Discarded"
      goal.update(status: "discarded")
    end
    goal
  end

  def comment_params
    params.require(:comment).permit(:title, :user_id, :goal_id, :status)
  end
end
