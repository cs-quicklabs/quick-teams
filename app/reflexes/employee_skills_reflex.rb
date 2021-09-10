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

  def select
    employee = User.find(element.dataset["employee-id"])
    skill = Skill.find(element.dataset["skill-id"])
    if employee.skills.include? skill
      employee.skills.destroy skill
    else
      employee.skills << skill
    end
    skills = Skill.order("lower(name) asc")
    morph "#{dom_id(skill)}", render(partial: "employee/skills/skill", locals: { employee: employee, skill: skill, selected: employee.skills.include?(skill) })
  end
end
