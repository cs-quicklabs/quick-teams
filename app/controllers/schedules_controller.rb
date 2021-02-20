class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/profile", locals: { message: "User was updated successfully", user: @user }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/profile", locals: { user: @user }) }
      end
    end
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was added created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { redirect_to new_person_path(@user) }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def build_form
    @form = ChangePasswordForm.new(@user)
  end
end
