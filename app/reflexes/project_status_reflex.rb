class ProjectStatusReflex < ApplicationReflex
  def change
    project = Project.find(element.dataset["project-id"])
    project.update(status_id: element.dataset["status-id"])
    project.save
    morph "#project-status", render(partial: "project/status", locals: { project: project })
  end

  def remove
    project = Project.find(element.dataset["project-id"])
    project.update(status_id: nil)
    project.save!
    morph "#project-status", render(partial: "project/status", locals: { project: project })
  end
end
