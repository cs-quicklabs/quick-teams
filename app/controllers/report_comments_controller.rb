class ReportCommentsController < BaseController
  before_action :set_report, only: :create

  def create
    authorize [@report.reportable, @report], :comment?

    @comment = AddCommentOnReport.call(comment_params, @report, params[:commit], current_user).result
    respond_to do |format|
      if @comment.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.append(:comments, partial: "shared/comments/comment", locals: { comment: @comment }) +
                               turbo_stream.replace("comment", partial: "shared/comments/report", locals: { report: @report, comment: Comment.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:add, partial: "shared/comments/report", locals: { report: @report, comment: @comment }) }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :user_id, :commentable_id, :status)
  end

  private

  def set_report
    @report ||= Report.find(comment_params["commentable_id"])
  end
end
