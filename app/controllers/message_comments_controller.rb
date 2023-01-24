class MessageCommentsController < BaseController
  before_action :set_message, only: [:edit, :update, :destroy]

  def create
    authorize MessageComment

    @comment = AddCommentOnMessage.call(comment_params, comment_params[:message_id], current_user.id).result
    @message = @comment.message
    respond_to do |format|
      if @comment.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.update("add", partial: "message_comments/new", locals: { space_message: @message, comment: MessageComment.new, url: message_comments_path, method: "post" }) +
                               turbo_stream.append(:comments, partial: "message_comments/message_comment", locals: { comment: @comment })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("add", partial: "message_comments/form", locals: { space_message: @message, comment: @comment, url: message_comments_path, method: "post" }) }
      end
    end
  end

  def edit
    authorize @comment
    @space_message = @message
  end

  def update
    authorize @comment
    respond_to do |format|
      if @comment.update(comment_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, partial: "message_comments/message_comment", locals: { comment: @comment }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, template: "message_comments/edit", locals: { comment: @comment, space_message: @message }) }
      end
    end
  end

  def destroy
    authorize @comment
    @comment.destroy
    redirect_to space_message_path(@comment.message.space, @comment.message), notice: "Comment was successfully destroyed."
  end

  private

  def comment_params
    params.require(:message_comment).permit(:body, :message_id, :user_id)
  end

  def set_message
    @comment = MessageComment.find(params[:id])
    @message = @comment.message
  end
end
