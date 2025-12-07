class InviteEmployeeReflex < ApplicationReflex
  def invite
    employee = User.find(element.dataset["employee-id"])
    employee.invite!
    morph dom_id(employee, :user), render(partial: "employees/employee", locals: { employee: employee })
  end
end
