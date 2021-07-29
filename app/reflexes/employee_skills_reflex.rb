class EmployeeSkillsReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def add
    employee = User.find(element.dataset["employee-id"])
    employee.skills << Skill.find(element.dataset["skill-id"])
    morph "#skills", render(partial: "employee/skills/form", locals: { employee: employee, skills: employee.skills, skill: Skill.new, user: current_user })
  end

  def remove
    employee = User.find(element.dataset["employee-id"])
    employee.skills.destroy Skill.find(element.dataset["skill-id"])

    morph "#employee-skills", render(partial: "employee/skills/skills", locals: { employee: employee, skills: employee.skills, user: current_user })
  end
end
