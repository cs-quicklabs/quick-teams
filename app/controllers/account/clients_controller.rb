class Account::ClientsController < Account::BaseController
  before_action :set_client, only: %i[ show edit update destroy ]

  # GET /clients or /clients.json
  def index
    @clients = Client.all
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients or /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.turbo_stream { render turbo_stream: turbo_stream.prepend(:clients, partial: "account/clients/client", locals: { message: "Client was created successfully.", client: @client }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Client.new, partial: "account/clients/form", locals: {}) }
      end
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@client, partial: "account/clients/client", locals: { message: "Client was created successfully.", client: @client }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@client, partial: "account/clients/client", locals: { client: @client }) }
      end
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@client) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def client_params
    params.require(:client).permit(:name, :email, :account_id)
  end
end
