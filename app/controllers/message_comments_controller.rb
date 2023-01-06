class MessageCommentsController < BaseController
  before_action :set_message, only: :create

  def create
    authorize [@message.space, @message], :comment?
    @comment = AddCommentOnMessage.call(comment_params, @message, current_user).result

    respond_to do |format|
      if @comment.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.append(:comments, partial: "shared/comments/body", locals: { comment: @comment }) +
                               turbo_stream.replace("add", partial: "shared/comments/new", locals: { space_message: @message, comment: Comment.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:add, partial: "shared/comments/new", locals: { space_message: @message, comment: @comment }) }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :commentable_id, :title)
  end

  def set_message
    @message = Message.find(comment_params[:commentable_id])
  end
end
