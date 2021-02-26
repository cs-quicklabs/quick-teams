class Projects::NotesController < ApplicationController
  before_action :set_project, only: %i[ index show edit update destroy ]
  before_action :set_note, only: %i[ destroy ]

  def index
    @notes = NoteDecorator.decorate_collection(@project.notes)
  end

  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to project_notes_path(@project), notice: "Note was removed successfully." }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params["project_id"]).decorate
  end

  def set_note
    @note = Note.find(params["id"])
  end
end
