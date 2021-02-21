class UserController < ApplicationController
	before_action :authenticate_user!
	before_action :set_user
	before_action :password_form, only: [:password_update, :password]
	decorates_assigned :user

	def update
		# @user_decorator = helpers.decorate(current_user)
		respond_to do |format|
			if @user.update(user_params)
				format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "settings/forms/profile", locals: { message: "User was updated successfully", user: @user }) }
			else
				format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "settings/forms/profile", locals: { user: @user }) }
			end
		end
	end

	def password_update
		# @password_form = PasswordForm.new(current_user)
		respond_to do |format|
			if @password_form.submit(password_params)
				format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/password", locals: { message: "Password was updated successfully", user: @user }) }
			else
				format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/password", locals: { user: @user }) }
			end
		end
	end

	def password
	end

	def profile
	end

	private

	def set_user
		@user = current_user
	end
	def password_form
		@password_form = PasswordForm.new(@user)
	end

	def user_params
		params.require(:user).permit(:first_name, :last_name, :email)
	end

	def password_params
		params.require(:user).permit(:password, :new_password, :confirm_new_password)
	end
end
