class UserController < BaseController
  include ActiveStorage::SetCurrent
  before_action :set_user
  before_action :build_form, only: [:update_password, :password]

  def update
    authorize @user

    respond_to do |format|
      if @user.update(user_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/profile", locals: { message: "User was updated successfully", user: @user }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/profile", locals: { user: @user }) }
      end
    end
  end

  def update_password
    authorize @user
    respond_to do |format|
      if @form.submit(change_password_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/password", locals: { message: "Password was updated successfully", user: @user }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/password", locals: { user: @user }) }
      end
    end
  end

  def update_avatar
    authorize @user
    respond_to do |format|
      if @user.avatar.attach(params[:user][:avatar])
        format.html { redirect_to profile_path, notice: "Avatar was updated successfully" }
      else
        format.html { redirect_to profile_path, alert: "Invalid file added" }
      end
    end
  end

  def destroy_avatar
    authorize @user
    respond_to do |format|
      if @user.avatar.purge
        format.html { redirect_to profile_path, notice: "Avatar was deleted successfully" }
      else
        format.html { redirect_to profile_path, alert: "Avatar was not deleted" }
      end
    end
  end

  def preferences
    authorize @user
  end

  def profile
    authorize @user
  end

  def password
    authorize @user
  end

  private

  def set_user
    @user ||= current_user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role_id, :manager_id, :job_id, :discipline_id, :avatar)
  end

  def change_password_params
    params.require(:user).permit(:original_password, :new_password, :new_password_confirmation)
  end

  def build_form
    @form ||= ChangePasswordForm.new(@user)
  end
end
