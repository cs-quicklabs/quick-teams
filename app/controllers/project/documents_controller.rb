class Project::DocumentsController < Project::BaseController
  before_action :set_document, only: %i[destroy]

  def index
    authorize [@project, Document]

    @document = Document.new
    @pagy, @documents = pagy_nil_safe(Document.where(document_type: "Project").where(document_id: @project).includes({ user: [:role, :job] }).order(created_at: :desc))

    render_partial("project/documents/document", collection: @documents) if stale?(@documents + [@project])
  end

  def create
    authorize [@project, Document]

    @document = AddProjectDocument.call(@project, document_params, current_user).result
    respond_to do |format|
      if @document.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:documents, partial: "project/documents/document", locals: { document: @document }) +
                               turbo_stream.replace(Document.new, partial: "project/documents/form", locals: { document: Document.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Document.new, partial: "project/documents/form", locals: { document: @document }) }
      end
    end
  end

  def destroy
    authorize [@project, @document]

    @document.destroy
    Event.where(eventable: @project, trackable: @document).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@document) }
    end
  end

  private

  def set_document
    @document ||= Document.find(params["id"])
  end

  def document_params
    params.require(:document).permit(:filename, :comments, :link)
  end
end
