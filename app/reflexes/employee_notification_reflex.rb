class EmployeeNotificationReflex < ApplicationReflex
  def toggle_email_notification
    @user = User.find(element.dataset[:id])
    @user.update(email_enabled: !@user.email_enabled)
  end
end
