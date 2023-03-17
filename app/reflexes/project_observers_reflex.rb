class ProjectObserversReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def add
    @project = Project.find(element.dataset["project-id"])
    @observer = User.find(element.dataset["employee-id"])
    @project.observers << @observer
    EmployeeMailer.with(employee: @observer, project: @project).observer_email.deliver_later
    @project.events.create(user: current_user, action: "observer", action_for_context: "as project observer", trackable: @observer)
    morph "#add-observers", render(partial: "project/about/observers", locals: { observers: @project.observers, project: @project, message: "Observer added successfully" })
  end

  def add_project
    @project = Project.find(element.dataset["project-id"])
    @employee = User.find(element.dataset["employee-id"])
    @employee.observed_projects << @project
    EmployeeMailer.with(employee: @employee, project: @project).observer_email.deliver_later
    @project.events.create(user: current_user, action: "observer", action_for_context: "as project observer", trackable: @employee)
    morph "#add-observed-projects", render(partial: "employee/about/observed_projects", locals: { observed_projects: @employee.observed_projects, employee: @employee, message: "Observed project added successfully" })
  end
end
