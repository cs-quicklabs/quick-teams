class DeactivateUser < Patterns::Service
  def initialize(user, actor)
    @user = user
    @actor = actor
  end

  def call
    remove_as_people_manager
    remove_as_project_manager
    remove_reporting_manager
    remove_report_templates
    clear_schedules
    discard_goals
    clear_todos
    submit_pending_reports
    destroy_observers
    deactivate
    add_event
    user
  rescue StandardError
    user
  end

  private

  attr_reader :user, :actor

  def remove_as_people_manager
    user.subordinates.update_all(manager_id: nil, updated_at: Time.current)
  end

  def remove_as_project_manager
    Project.where(manager_id: user.id).update_all(manager_id: nil, updated_at: Time.current)
  end

  def remove_reporting_manager
    user.update!(manager_id: nil)
  end

  def remove_report_templates
    user.templates_assignees.delete_all
  end

  def clear_schedules
    Schedule.where(user: user).find_each do |schedule|
      schedule.destroy!
      schedule.project.reset_billable_resources
    end
  end

  def deactivate
    user.update!(active: false, deactivated_on: Time.current)
  end

  def discard_goals
    user.goals.pending.find_each do |goal|
      goal.comments.create!(
        user_id: actor.id,
        commentable_id: goal.id,
        title: "Discarding as employee has been deactivated.",
        status: "stale",
      )
      goal.update!(status: "discarded")
    end
  end

  def clear_todos
    user.todos.pending.delete_all
  end

  def submit_pending_reports
    user.reports.update_all(submitted: true)
  end

  def add_event
    user.events.create!(
      user: actor,
      action: "deactivated",
      action_for_context: "deactivated",
      trackable: user,
    )
  end

  def destroy_observers
    user.observing_projects.destroy_all
  end
end
