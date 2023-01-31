class UpdateEmployee < Patterns::Service
  def initialize(employee, params, actor)
    @employee = employee
    @actor = actor
    @params = params
  end

  def call
    begin
      send_email
      update_employee
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
    if employee.manager_id != params[:manager_id]
      @manager = User.find(params[:manager_id])
      ManagerMailer.with(employee: employee, manager: employee.manager).relieved_email.deliver_later if deliver_email?
      ManagerMailer.with(employee: employee, manager: @manager).updated_email.deliver_later if deliver_email?
      ManagerMailer.with(employee: employee, manager: @manager).manager_email.deliver_later if deliver_email?
    end
  end

  def deliver_email?
    employee.email_enabled and employee.account.email_enabled and employee.sign_in_count > 0
  end

  attr_reader :employee, :params, :actor
end
