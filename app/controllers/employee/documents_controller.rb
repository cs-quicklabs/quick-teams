class Employee::DocumentsController < Employee::BaseController
  before_action :set_document, only: %i[destroy]

  def index
    authorize [@employee, Document]

    @document = Document.new
    @pagy, @documents = pagy_nil_safe(Document.where(document_type: "User").includes({ user: [:role, :job] }).order(created_at: :desc))

    render_partial("employee/documents/document", collection: @documents) if stale?(@documents + [@employee])
  end

  def create
    authorize [@employee, Document]

    @document = AddEmployeeDocument.call(@employee, document_params, current_user).result
    respond_to do |format|
      if @document.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:documents, partial: "employee/documents/document", locals: { document: @document }) +
                               turbo_stream.replace(Document.new, partial: "employee/documents/form", locals: { document: Document.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Document.new, partial: "employee/documents/form", locals: { document: @document }) }
      end
    end
  end

  def destroy
    authorize [@employee, @document]

    @document.destroy
    Event.where(eventable: @employee, trackable: @document).touch_all #fixes cache issues in activity
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
