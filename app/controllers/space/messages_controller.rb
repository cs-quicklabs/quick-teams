class Space::MessagesController < Space::BaseController
  before_action :set_message, only: %i[ show edit update destroy ]

  def index
    authorize [@space, :message]
    @messages = @space.messages.order(created_at: :desc)
  end

  def new
    authorize [@space, :message]
    @space_message = Message.new
  end

  def create
    authorize [@space, :message]
    @message = Message.new(message_params)
    respond_to do |format|
      if @message.save
        format.html { redirect_to space_messages_path(@space), notice: "Message was created successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Message.new, partial: "space/messages/form", locals: { space_message: @message, title: "Add New Message", subtitle: "Add new message into #{@space.title}", space: @space }) }
      end
    end
  end

  def show
    authorize [@space, @message]
    @comment = Comment.new
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:title, :body, :user_id, :space_id)
  end
end
