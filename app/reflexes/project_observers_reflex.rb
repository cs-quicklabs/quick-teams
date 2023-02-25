class ProjectObserversReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def add
    @project = Project.find(element.dataset["project-id"])
    @observer = User.find(element.dataset["employee-id"])
    @project.observers << @observer
    EmployeeMailer.with(employee: @observer, project: @project).observer_email.deliver_later
    @project.events.create(user: current_user, action: "observer", action_for_context: "as project observer", trackable: @observer)
    morph "#add-observers", render(partial: "project/about/observer", locals: { observers: @project.observers, project: @project, message: "Observer added successfully" })
  end
end
