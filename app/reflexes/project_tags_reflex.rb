class ProjectTagsReflex < ApplicationReflex
  def change
    project.project_tags << tag
    morph_tags
  end

  def remove
    project.project_tags.destroy(tag)
    morph_tags
  end

  private

  def project
    @project ||= Project.find(element.dataset["project-id"])
  end

  def tag
    @tag ||= ProjectTag.find(element.dataset["tag-id"])
  end

  def morph_tags
    project.touch
    morph "#project-tags", render(partial: "project/tags", locals: { project: project, tags: project.project_tags })
  end
end
