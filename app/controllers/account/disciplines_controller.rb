class Account::DisciplinesController < Account::BaseController
  before_action :set_discipline, only: %i[ show edit update destroy ]

  def index
    @disciplines = Discipline.all
    @discipline = Discipline.new
  end

  def edit
  end

  def create
    @discipline = Discipline.new(discipline_params)

    respond_to do |format|
      if @discipline.save
        format.turbo_stream { render turbo_stream: turbo_stream.prepend(:disciplines, partial: "account/disciplines/discipline", locals: { message: "Discipline was created successfully.", discipline: @discipline }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Discipline.new, partial: "account/disciplines/form", locals: {}) }
      end
    end
  end

  def update
    respond_to do |format|
      if @discipline.update(discipline_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@discipline, partial: "account/disciplines/discipline", locals: { message: "Discipline was created successfully.", discipline: @discipline }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@discipline, partial: "account/disciplines/discipline", locals: { discipline: @discipline }) }
      end
    end
  end

  def destroy
    @discipline.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@discipline) }
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
