class ProjectTagsReflex < ApplicationReflex
  def change
    project = Project.find(element.dataset["project-id"])
    project.project_tags << ProjectTag.find(element.dataset["tag-id"])
    project.touch
    morph "#project-tags", render(partial: "project/tags", locals: { project: project, tags: project.project_tags })
  end

  def remove
    project = Project.find(element.dataset["project-id"])
    project.project_tags.destroy ProjectTag.find(element.dataset["tag-id"])
    project.touch
    morph "#project-tags", render(partial: "project/tags", locals: { project: project, tags: project.project_tags })
  end
end
