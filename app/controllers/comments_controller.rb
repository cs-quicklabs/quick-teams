class CommentsController < BaseController
  before_action :set_goal, only: :create

  def create
    authorize @goal, :comment?

    @comment = AddComment.call(comment_params, @goal, params[:commit], current_user).result
    respond_to do |format|
      if @comment.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.append(:comments, partial: "shared/comments/comment", locals: { comment: @comment }) +
                               turbo_stream.replace("add", partial: "shared/comments/add", locals: { goal: @goal, comment: Comment.new }) +
                               turbo_stream.replace("title", partial: "shared/goals/title", locals: { goal: @goal })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:add, partial: "shared/comments/add", locals: { goal: @goal, comment: @comment }) }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :user_id, :goal_id, :status)
  end

  private

  def set_goal
    @goal ||= Goal.find(comment_params["goal_id"])
  end
end
