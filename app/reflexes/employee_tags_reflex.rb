class EmployeeTagsReflex < ApplicationReflex
  def change
    employee.people_tags << tag
    morph_tags
  end

  def remove
    employee.people_tags.destroy(tag)
    morph_tags
  end

  private

  def employee
    @employee ||= User.find(element.dataset["employee-id"])
  end

  def tag
    @tag ||= PeopleTag.find(element.dataset["tag-id"])
  end

  def morph_tags
    morph "#employee-tags", render(partial: "employee/tags", locals: { employee: employee, tags: employee.people_tags })
  end
end
