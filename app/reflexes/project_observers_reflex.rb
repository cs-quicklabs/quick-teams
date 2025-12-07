class ProjectObserversReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def add
    project.observers << observer
    send_observer_email(observer)
    create_observer_event(observer)
    morph "#add-observers", render(partial: "project/about/observers", locals: {
                               observers: project.observers,
                               project: project,
                               message: "Observer added successfully",
                             })
  end

  def add_project
    employee.observed_projects << project
    send_observer_email(employee)
    create_observer_event(employee)
    morph "#add-observed-projects", render(partial: "employee/about/observed_projects", locals: {
                                       observed_projects: employee.observed_projects,
                                       employee: employee,
                                       message: "Observed project added successfully",
                                     })
  end

  private

  def project
    @project ||= Project.find(element.dataset["project-id"])
  end

  def observer
    @observer ||= User.find(element.dataset["employee-id"])
  end

  def employee
    @employee ||= User.find(element.dataset["employee-id"])
  end

  def send_observer_email(user)
    EmployeeMailer.with(employee: user, project: project).observer_email.deliver_later
  end

  def create_observer_event(user)
    project.events.create(user: current_user, action: "observer", action_for_context: "as project observer", trackable: user)
  end
end
