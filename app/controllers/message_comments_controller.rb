class MessageCommentsController < BaseController
  before_action :set_message, only: [:create, :edit, :update]

  def create
    authorize [@message.space, @message], :comment?
    @comment = AddCommentOnMessage.call(comment_params, @message, current_user).result

    respond_to do |format|
      if @comment.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("add", partial: "message_comments/new", locals: { space_message: @message, comment: Comment.new, url: message_comments_path, method: "post" }) +
                               turbo_stream.append(:comments, partial: "message_comments/message_comment", locals: { comment: @comment })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:add, partial: "message_comments/new", locals: { space_message: @message, comment: @comment, url: message_comments_path, method: "post" }) }
      end
    end
  end

  def edit
    authorize [@message.space, @message], :edit_comment?
    @space_message = @message
  end

  def update
    authorize [@message.space, @message], :edit_comment?
    @comment.title = comment_params[:body]
    respond_to do |format|
      if @comment.update(comment_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, partial: "message_comments/message_comment", locals: { comment: @comment }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, template: "message_comments/edit", locals: { comment: @comment, space_message: @message }) }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :commentable_id, :title)
  end

  def set_message
    @message = Message.find(comment_params[:commentable_id]) if params["comment"].present?
    @comment = Comment.find(params[:id]) if params["id"].present?
    @message ||= @comment.commentable
  end
end
