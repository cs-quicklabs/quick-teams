class Account::ClientsController < Account::BaseController
  before_action :set_client, only: %i[ show edit update destroy ]

  def index
    authorize :account

    @clients = Client.all.order(created_at: :desc)
    @client = Client.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:clients, partial: "account/clients/client", locals: { client: @client }) +
                               turbo_stream.replace(Client.new, partial: "account/clients/form", locals: { client: Client.new, message: "Client was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Client.new, partial: "account/clients/form", locals: { client: @client }) }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @client.update(client_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@client, partial: "account/clients/client", locals: { client: @client, message: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@client, template: "account/clients/edit", locals: { client: @client, messages: @client.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @client.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@client) }
    end
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :email, :account_id)
  end
end
