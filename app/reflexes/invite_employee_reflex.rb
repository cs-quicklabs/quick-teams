class InviteEmployeeReflex < ApplicationReflex
  def invite
    employee = User.find(element.dataset["employee-id"])
    employee.invite!
    morph "#user_#{employee.id}", render(partial: "employees/employee", locals: { employee: employee })
  end
end
