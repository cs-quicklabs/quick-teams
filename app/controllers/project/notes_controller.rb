class Project::NotesController < Project::BaseController
  before_action :set_note, only: %i[ destroy ]

  def index
    @notes = NoteDecorator.decorate_collection(@project.notes.order(created_at: :desc))
    @note = Note.new
  end

  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to project_notes_path(@project), notice: "Note was removed successfully." }
    end
  end

  def create
    @note = AddNote.call(@project, note_params, current_user).result
    respond_to do |format|
      if @note.persisted?
        @note = Note.new
        format.html { redirect_to project_notes_path(@project), notice: "Note was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Note.new, partial: "project/notes/form", locals: { note: @note }) }
      end
    end
  end

  private

  def set_note
    @note = Note.find(params["id"])
  end

  def note_params
    params.require(:note).permit(:body)
  end
end
