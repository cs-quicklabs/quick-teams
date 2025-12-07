class ProjectSkillsReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def add
    project.skills << skill
    morph "#skills", render(partial: "project/skills/form", locals: {
                        project: project,
                        skills: project.skills,
                        skill: Skill.new,
                        user: current_user,
                      })
  end

  def remove
    project.skills.destroy(skill)
    morph "#project-skills", render(partial: "project/skills/skills", locals: {
                                project: project,
                                skills: project.skills,
                                user: current_user,
                              })
  end

  private

  def project
    @project ||= Project.find(element.dataset["project-id"])
  end

  def skill
    @skill ||= Skill.find(element.dataset["skill-id"])
  end
end
