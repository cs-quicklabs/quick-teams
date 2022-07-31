class Project::ClientsController < Project::BaseController
  def index
    authorize [@project, Client]

    @client = Client.new
    @clients = @project.clients
  end

  def create
    authorize [@project, Client]

    @project.clients << Client.find(params[:client][:client_id])
    project_client = @project.clients.find(params[:client][:client_id])
    client = Client.new
    respond_to do |format|
      if project_client.present?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:clients, partial: "project/clients/client", locals: { client: project_client }) +
                               turbo_stream.replace(Client.new, partial: "project/clients/form", locals: { client: client })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Client.new, partial: "project/clients/form", locals: { client: client }) }
      end
    end
  end

  def destroy
    authorize [@project, Client]

    client = @project.clients.find(params[:id])
    @project.clients.destroy(params[:id])
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.remove(client) +
                             turbo_stream.replace(Client.new, partial: "project/clients/form", locals: { client: Client.new })
      }
    end
  end
end
