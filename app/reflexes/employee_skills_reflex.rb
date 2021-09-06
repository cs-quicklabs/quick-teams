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
    if employee.skills.map{|skill| skill.id}.include?(element.dataset["skill-id"].to_i)
      employee.skills.destroy Skill.find(element.dataset["skill-id"]) 
       else
        employee.skills << Skill.find(element.dataset["skill-id"])
       end
    skills= Skill.order("lower(name) asc")
    morph "#skill_select", render(partial: "employee/skills/list", locals: { employee: employee, employee_skills: employee.skills, user: current_user, skills: skills })
  end
end
