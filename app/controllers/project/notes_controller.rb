class Project::NotesController < Project::BaseController
  before_action :set_note, only: %i[ destroy edit update ]

  def index
    authorize [@project, Note]

    @note = Note.new
    @pagy, @notes = pagy_nil_safe(@project.notes.includes(:user).order(created_at: :desc), items: LIMIT)
    render_partial("project/notes/note", collection: @notes) if stale?(@notes + [@project])
  end

  def destroy
    authorize [@project, @note]

    @note.destroy
    Event.where(eventable: @project, trackable: @note).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@note) }
    end
  end

  def edit
    authorize [@project, @note]
  end

  def update
    authorize [@project, @note]

    respond_to do |format|
      if @note.update(note_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@note, partial: "project/notes/note", locals: { note: @note }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@note, template: "project/notes/edit", locals: { note: @note }) }
      end
    end
  end

  def create
    authorize [@project, Note]

    @note = AddNote.call(@project, note_params, current_user).result
    respond_to do |format|
      if @note.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:notes, partial: "project/notes/note", locals: { note: @note }) +
                               turbo_stream.replace(Note.new, partial: "project/notes/form", locals: { note: Note.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Note.new, partial: "project/notes/form", locals: { note: @note }) }
      end
    end
  end

  private

  def set_note
    @note ||= Note.find(params["id"])
  end

  def note_params
    params.require(:note).permit(:body)
  end
end
