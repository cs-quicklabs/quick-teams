class EmployeeStatusReflex < ApplicationReflex
  def change
    update_status(element.dataset["status-id"])
  end

  def remove
    update_status(nil)
  end

  private

  def employee
    @employee ||= User.find(element.dataset["employee-id"])
  end

  def update_status(status_id)
    employee.update(status_id: status_id)
    employee.schedules.touch_all
    morph "#employee-status", render(partial: "employee/status", locals: { employee: employee })
  end
end
