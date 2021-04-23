class EmployeeTagsReflex < ApplicationReflex
  def change
    employee = User.find(element.dataset["employee-id"])
    employee.people_tags << PeopleTag.find(element.dataset["tag-id"])
    morph "#employee-tags", render(partial: "employee/tags", locals: { employee: employee, tags: employee.people_tags })
  end

  def remove
    employee = User.find(element.dataset["employee-id"])
    employee.people_tags.destroy PeopleTag.find(element.dataset["tag-id"])

    morph "#employee-tags", render(partial: "employee/tags", locals: { employee: employee, tags: employee.people_tags })
  end
end
