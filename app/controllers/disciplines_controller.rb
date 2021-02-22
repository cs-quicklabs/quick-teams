class DisciplinesController < ApplicationController
  before_action :set_discipline, only: %i[ show edit update destroy ]

  def index
    @disciplines = Discipline.all
    @discipline = Discipline.new
  end

  def new
    @discipline = Discipline.new
  end

  def create
    @discipline = Discipline.new(discipline_params)

    respond_to do |format|
      if @discipline.save
        @discipline = Discipline.new
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Discipline.new, partial: "disciplines/form", locals: { message: "Discipline was created successfully." }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Discipline.new, partial: "disciplines/form", locals: {}) }
      end
    end
  end

  def update
    respond_to do |format|
      if @discipline.update(discipline_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@discipline, partial: "disciplines/discipline", locals: { message: "Discipline was created successfully.", discipline: @discipline }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@discipline, partial: "disciplines/discipline", locals: { discipline: @discipline }) }
      end
    end
  end

  def destroy
    @discipline.destroy
    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

  private

  def set_discipline
    @discipline = Discipline.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def discipline_params
    params.require(:discipline).permit(:name, :account_id)
  end
end
