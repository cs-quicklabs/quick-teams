class CommentsController < BaseController
  before_action :set_goal, only: :create

  def edit
    authorize @comment
  end

  def update
    authorize @comment

    respond_to do |format|
      if @comment.update(comment_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, partial: "shared/comments/comment", locals: { comment: @comment }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@schedule, partial: "shared/comments/comment", locals: { comment: @comment }) }
      end
    end
  end

  def destroy
    authorize @comment
    @comment.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@comment) }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :user_id, :commentable_id, :status)
  end

  private

  def set_goal
    @goal ||= Goal.find(comment_params["commentable_id"])
  end
end
