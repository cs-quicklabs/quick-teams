class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.append(:comments, partial: "employee/goals/comments/comment", locals: { comment: @comment }) +
                               turbo_stream.replace(:add, partial: "employee/goals/comments/add", locals: { goal: @goal, comment: Comment.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:add, partial: "employee/goals/comments/add", locals: { goal: @goal, comment: @comment }) }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :user_id, :goal_id, :status)
  end
end
