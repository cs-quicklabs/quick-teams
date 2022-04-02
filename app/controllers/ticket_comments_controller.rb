class TicketCommentsController < BaseController
    before_action :set_ticket, only: :create
  
    def create
      authorize [@ticket], :comment?
      @comment = AddCommentOnTicket.call(comment_params, @ticket, params[:commit], current_user).result
      respond_to do |format|
        if @comment.persisted?
          format.turbo_stream {
            render turbo_stream: turbo_stream.append(:comments, partial: "shared/comments/comment", locals: { comment: @comment }) +
                                 turbo_stream.replace("comment", partial: "shared/comments/ticket", locals: { ticket: @ticket, comment: Comment.new })
          }
        else
          format.turbo_stream { render turbo_stream: turbo_stream.replace(:comment, partial: "shared/comments/ticket", locals: { ticket: @ticket, comment: @comment }) }
        end
      end
    end
  
    private
  
    def set_ticket
      @ticket ||= Ticket.find(comment_params["commentable_id"])
    end
  
    def comment_params
      params.require(:comment).permit(:title, :user_id, :commentable_id, :status)
    end
end