class RemoveObserver < Patterns::Service
  def initialize(project, observer, actor)
    @project = project
    @observer = observer
    @actor = actor
  end

  def call
    remove_observer
    send_email
    add_event
    begin
    rescue
      project
    end
    project
  end

  private

  def remove_observer
    project.observers.delete(@observer)
  end

  def add_event
    observer.events.create(user: actor, action: "observer_removed", action_for_context: "as observer", trackable: project)
  end

  def send_email
    EmployeeMailer.with(employee: observer, project: project).observer_removed_email.deliver_later if deliver_email?(observer)
  end

  def deliver_email?(employee)
    employee.email_enabled and employee.account.email_enabled and employee.sign_in_count > 0
  end

  attr_reader :actor, :observer, :project
end
