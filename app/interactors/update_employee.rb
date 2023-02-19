class UpdateEmployee < Patterns::Service
  def initialize(employee, params, actor)
    @employee = employee
    @actor = actor
    @params = params
  end

  def call
    begin
      update_employee
      send_email
    rescue
      employee
    end
    employee
  end

  private

  def update_employee
    employee.update(params)
  end

  def send_email
    return unless deliver_email?
    if employee.saved_change_to_attribute?(:manager_id)
      @manager = User.find(employee.manager_id_before_last_save)
      EmployeeMailer.with(employee: employee, manager: @manager).relieved_email.deliver_later
      EmployeeMailer.with(employee: employee, manager: employee.manager).updated_manager_email.deliver_later
      EmployeeMailer.with(employee: employee, manager: employee.manager).manager_email.deliver_later
    end
    if employee.saved_change_to_attribute?(:role_id)
      @role = employee.role.name
      EmployeeMailer.with(employee: employee, role: @role).role_changed_email.deliver_later
    end
  end

  def deliver_email?
    employee.email_enabled and employee.account.email_enabled and employee.sign_in_count > 0
  end

  attr_reader :employee, :params, :actor
end
