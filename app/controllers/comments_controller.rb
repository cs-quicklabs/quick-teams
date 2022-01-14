class CommentsController < BaseController
  before_action :set_commentable, only: :create
  before_action :set_comment, only: %i[ update destroy edit ]

  def create
    authorize [@user, @commentable], :comment?

    @comment = AddComment.call(comment_params, @commentable, params[:commit], current_user).result
    respond_to do |format|
      if @comment.persisted?
        if @commentable.class == "Goal"
          format.turbo_stream {
            render turbo_stream: turbo_stream.append(:comments, partial: "shared/comments/comment", locals: { comment: @comment }) +
                                 turbo_stream.replace("add", partial: "shared/comments/add", locals: { commentable: @commentable, comment: Comment.new }) +
                                 turbo_stream.replace("title", partial: "shared/goals/title", locals: { commentable: @commentable })
          }
        else
          format.turbo_stream {
            render turbo_stream: turbo_stream.append(:comments, partial: "shared/comments/comment", locals: { comment: @comment }) +
                                 turbo_stream.replace("add", partial: "shared/comments/add", locals: { commentable: @commentable, comment: Comment.new })
          }
        end
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:add, partial: "shared/comments/add", locals: { goal: @goal, comment: @comment }) }
      end
    end
  end

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
    params.require(:comment).permit(:title, :user_id, :commentable_id, :status, :commentable_type)
  end

  def set_comment
    @comment ||= Comment.find(params["id"])
  end

  def set_commentable
    if comment_params["commentable_type"] == "Goal"
      @commentable ||= Goal.find(comment_params["commentable_id"])
      @user = @commentable.goalable
    else
      @commentable ||= Report.find(comment_params["commentable_id"])
      @user = @commentable.reportable
    end
  end
end
