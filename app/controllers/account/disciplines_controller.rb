class Account::DisciplinesController < Account::BaseController
  before_action :set_discipline, only: %i[ show edit update destroy ]

  def index
    @disciplines = Discipline.all.order(created_at: :desc)
    @discipline = Discipline.new
  end

  def edit
  end

  def create
    @discipline = Discipline.new(discipline_params)

    respond_to do |format|
      if @discipline.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:disciplines, partial: "account/disciplines/discipline", locals: { discipline: @discipline }) +
                               turbo_stream.replace(Discipline.new, partial: "account/disciplines/form", locals: { discipline: Discipline.new, message: "Discipline was created successfully." })
        }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("new_discipline", partial: "account/disciplines/form", locals: { discipline: @discipline })
        }
      end
    end
  end

  def update
    respond_to do |format|
      if @discipline.update(discipline_params)
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(@discipline, partial: "account/disciplines/discipline", locals: { discipline: @discipline })
        }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(@discipline, partial: "account/disciplines/discipline", locals: { discipline: @discipline })
        }
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
