class UpdateEmployee < Patterns::Service
  def initialize(employee, params, actor)
    @employee = employee
    @actor = actor
    @params = params
  end

  def call
    update_employee
    send_emails
    employee
  rescue StandardError
    employee
  end

  private

  attr_reader :employee, :params, :actor

  def update_employee
    employee.update!(params)
  end

  def send_emails
    return unless deliver_email?

    send_manager_change_emails if employee.saved_change_to_attribute?(:manager_id)
    send_role_change_email if employee.saved_change_to_attribute?(:role_id)
  end

  def send_manager_change_emails
    previous_manager = User.find(employee.manager_id_before_last_save)
    previous_manager.touch

    EmployeeMailer.with(employee: employee, manager: previous_manager)
                  .relieved_email
                  .deliver_later

    EmployeeMailer.with(employee: employee, manager: employee.manager)
                  .updated_manager_email
                  .deliver_later

    EmployeeMailer.with(employee: employee, manager: employee.manager)
                  .manager_email
                  .deliver_later
  end

  def send_role_change_email
    EmployeeMailer.with(employee: employee, role: employee.role.name)
                  .role_changed_email
                  .deliver_later
  end

  def deliver_email?
    employee.email_enabled &&
      employee.account.email_enabled &&
      employee.sign_in_count.positive?
  end
end
