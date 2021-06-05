class Account::TagsController < Account::BaseController
  before_action :set_tag, only: %i[ destroy ]

  def index
    authorize :account

    @tags = Tag.all.order(created_at: :desc)
  end

  def destroy
    authorize :account

    @tag.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@tag) }
    end
  end

  private

  def set_tag
    @tag ||= Tag.find(params[:id])
  end
end
