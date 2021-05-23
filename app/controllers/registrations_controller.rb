class RegistrationsController < Devise::RegistrationsController
  before_action :build_form

  def new
    super
  end

  def create
    registered = @form.submit(registration_params)
    respond_to do |format|
      if registered
        format.html { redirect_to new_user_session_path }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("sign_up_form", partial: "devise/registrations/form", locals: { resource: @form }) }
      end
    end
  end

  private

  def registration_params
    params.require(:user).permit(:first_name, :last_name, :email, :new_password, :new_password_confirmation, :company)
  end

  def build_form
    @form ||= SignUpForm.new
  end
end
