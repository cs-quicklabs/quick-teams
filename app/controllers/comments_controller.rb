class CommentsController < BaseController
  before_action :set_goal, only: :create

  def create
    authorize @goal, :comment?

    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        update_goal
        format.turbo_stream {
          render turbo_stream: turbo_stream.append(:comments, partial: "shared/comments/comment", locals: { comment: @comment }) +
                               turbo_stream.replace("add", partial: "shared/comments/add", locals: { goal: @goal, comment: Comment.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:add, partial: "shared/comments/add", locals: { goal: @goal, comment: @comment }) }
      end
    end
  end

  private

  def update_goal
    if params[:commit] == "Comment"
    elsif params[:commit] == "and mark Missed"
      @goal.update(status: "missed")
    elsif params[:commit] == "and mark Completed"
      @goal.update(status: "completed")
    elsif params[:commit] == "and mark Discarded"
      @goal.update(status: "discarded")
    end
  end

  def comment_params
    params.require(:comment).permit(:title, :user_id, :goal_id, :status)
  end

  private

  def set_goal
    @goal ||= Goal.find(comment_params["goal_id"])
  end
end
