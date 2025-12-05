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
    project
  rescue StandardError
    project
  end

  private

  attr_reader :actor, :observer, :project

  def remove_observer
    project.observers.delete(observer)
  end

  def add_event
    project.events.create!(
      user: actor,
      action: "observer_removed",
      action_for_context: "as project observer",
      trackable: observer,
    )
  end

  def send_email
    return unless deliver_email?

    EmployeeMailer.with(employee: observer, project: project)
                  .observer_removed_email
                  .deliver_later
  end

  def deliver_email?
    observer.email_enabled &&
      observer.account.email_enabled &&
      observer.sign_in_count.positive?
  end
end
