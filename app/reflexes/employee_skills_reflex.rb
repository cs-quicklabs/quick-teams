class EmployeeSkillsReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def add
    employee.skills << skill
    morph "#skills", render(partial: "employee/skills/form", locals: {
                        employee: employee,
                        skills: employee.skills,
                        skill: Skill.new,
                        user: current_user,
                      })
  end

  def remove
    employee.skills.destroy(skill)
    morph "#employee-skills", render(partial: "employee/skills/skills", locals: {
                                 employee: employee,
                                 skills: employee.skills,
                                 user: current_user,
                               })
  end

  def select
    toggle_skill
    morph dom_id(skill), render(partial: "employee/skills/skill", locals: {
                            employee: employee,
                            skill: skill,
                            selected: employee.skills.include?(skill),
                          })
  end

  private

  def employee
    @employee ||= User.find(element.dataset["employee-id"])
  end

  def skill
    @skill ||= Skill.find(element.dataset["skill-id"])
  end

  def toggle_skill
    if employee.skills.include?(skill)
      employee.skills.destroy(skill)
    else
      employee.skills << skill
    end
  end
end
