class Account::PreferencesController < Account::BaseController
  before_action :set_account
  before_action :set_preference, only: [:update]

  def index
    authorize :account, :preferences?
    @preferences = Preference.all
  end

  def update
    authorize :account

    respond_to do |format|
      if @preference.update(preferences_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@preference, partial: "account/preferences/preference", locals: { preference: @preference })
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_preference
    @preference ||= Preference.find(params[:id])
  end

  def preferences_params
    params.require(:preference).permit(:key, :value)
  end

  def set_account
    @account ||= current_user.account
  end
end
