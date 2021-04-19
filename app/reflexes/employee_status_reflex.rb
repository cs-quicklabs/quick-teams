class EmployeeStatusReflex < ApplicationReflex
  def change
    employee = User.find(element.dataset["employee-id"])
    employee.update(status_id: element.dataset["status-id"])
    employee.save
    morph "#employee-status", render(partial: "employee/status", locals: { employee: employee })
  end

  def remove
    employee = User.find(element.dataset["employee-id"])
    employee.update(status_id: nil)
    employee.save!
    morph "#employee-status", render(partial: "employee/status", locals: { employee: employee })
  end
end
