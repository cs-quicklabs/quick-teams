class Space::MessagesController < Space::BaseController
  helper TrixAttachmentsHelper
  before_action :set_message, only: %i[ show edit update destroy ]
  before_action :set_space

  def index
    authorize [@space, :message]
    if params[:direction].present?
      @messages = @space.messages.order("created_at #{params[:direction]}")
    else
      @messages = @space.messages.order("created_at desc")
    end
  end

  def new
    authorize [@space, :message]
    @space_message = Message.new
  end

  def create
    authorize [@space, :message]
    @message = AddMessageToSpace.call(@space, Message.new(message_params), current_user, params[:draft], params[:send_email]).result

    respond_to do |format|
      if @message.persisted?
        format.html { redirect_to space_messages_path(@space), notice: "Thread was created successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Message.new, partial: "space/messages/form", locals: { space_message: @message, title: "Add New Thread", subtitle: "Threads are messages or discussion which can be added inside a space", space: @space, url: space_messages_path, method: "post" }) }
      end
    end
  end

  def edit
    authorize [@space, @message]
    @space_message = @message
  end

  def show
    authorize [@space, @message]
    @comment = MessageComment.new
  end

  def update
    authorize [@space, @message]
    @message = UpdateMessage.call(@space, @message, current_user, params[:draft], params[:send_email], message_params).result
    respond_to do |format|
      if @message.errors.empty?
        format.html { redirect_to space_messages_path(@space), notice: "Thread was updated successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@message, partial: "space/messages/form", locals: { space_message: @message, title: "Edit Thread", subtitle: "Please update thread into existing space#{@message.space.title}", space: @space, url: space_message_path(@space, @message), method: "patch" }) }
      end
    end
  end

  def destroy
    authorize [@space, @message]
    @message.destroy
    respond_to do |format|
      format.html { redirect_to space_messages_path(@space), notice: "Thread was removed successfully." }
    end
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:title, :body, :user_id, :space_id)
  end
end
