class PasswordsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_user

	# def new
	# 	@password_form = PasswordForm.new(current_user)
	# end

	def password_update
		@password_form = PasswordForm.new(current_user)
		respond_to do |format|
			if @password_form.submit(password_params)
				format.turbo_stream { render turbo_stream: turbo_stream.replace(@password_form, partial: "settings/forms/password", locals: { message: "Password was updated successfully", password_form: @password_form }) }
			else
				format.turbo_stream { render turbo_stream: turbo_stream.replace(@password_form, partial: "settings/forms/password", locals: { password_form: @password_form }) }
			end
		end
	end

	def password
		
	end
	# before_action :authenticate_user!
	# before_action :set_password
	# # decorates_assigned :user

	# def update
	# 	# @user_decorator = helpers.decorate(current_user)
	# 	respond_to do |format|
	# 		if @user.update(password_params)
	# 			format.turbo_stream { render turbo_stream: turbo_stream.replace(@password, partial: "settings/forms/password", locals: { message: "User was updated successfully", password: @password }) }
	# 		else
	# 			format.turbo_stream { render turbo_stream: turbo_stream.replace(@password, partial: "settings/forms/password", locals: { password: @password }) }
	# 		end
	# 	end
	# end

	# private

	# def set_password
	# 	@password = PasswordForm.current_user
	# end

	# def user_params
	# 	params.require(:PasswordForm).permit(:old_password, :new_password, :confirm_new_password)
	# end

	private


	def set_user
		@user = current_user
	end
	def password_params
		params.require(:@password_form).permit(:password, :new_password, :confirm_new_password)
	end
end


