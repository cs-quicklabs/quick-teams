class ProjectSkillsReflex < ApplicationReflex
  def add
    project = Project.find(element.dataset["project-id"])
    project.skills << Skill.find(element.dataset["skill-id"])
    morph "#skills", render(partial: "project/skills/form", locals: { project: project, skills: project.skills, skill: Skill.new })
  end

  def remove
    project = Project.find(element.dataset["project-id"])
    project.skills.destroy Skill.find(element.dataset["skill-id"])

    morph "#project-skills", render(partial: "project/skills/skills", locals: { project: project, skills: project.skills })
  end
end
