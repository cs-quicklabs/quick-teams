class Project::NotesController < Project::BaseController
  before_action :set_note, only: %i[ destroy ]

  def index
    authorize [:project, Note]
    @notes = @project.notes.order(created_at: :desc)
    @note = Note.new
  end

  def destroy
    authorize [:project, @note]

    @note.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@note) }
    end
  end

  def create
    authorize [:project, Note]

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
