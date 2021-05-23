class RegistrationsController < Devise::InvitationsController
  before_action :build_form

  def index
  end

  def create
    registered = @form.submit(account_params, user_params)
    binding.irb
    if registered
      redirect_to root_path(script_name: "")
    else
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def account_params
    params.require(:account).permit(:name)
  end

  def build_form
    @form ||= SignUpForm.new
  end
end
