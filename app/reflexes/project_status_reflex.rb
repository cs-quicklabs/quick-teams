class ProjectStatusReflex < ApplicationReflex
  def change
    update_status(element.dataset["status-id"])
  end

  def remove
    update_status(nil)
  end

  private

  def project
    @project ||= Project.find(element.dataset["project-id"])
  end

  def update_status(status_id)
    project.update!(status_id: status_id)
    morph "#project-status", render(partial: "project/status", locals: { project: project })
  end
end
