class ArchiveProject < Patterns::Service
  def initialize(project, actor)
    @project = project
    @actor = actor
  end

  def call
    clear_schedule
    clear_todos
    discard_milestones
    archive
    submit_pending_reports
    destroy_observers
    add_event
    project
  rescue StandardError => e
    Rails.logger.error "ArchiveProject failed: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.first(10).join("\n")
    project
  end

  private

  attr_reader :project, :actor

  def clear_schedule
    project.schedules.destroy_all
    project.billable_resources = 0.0
  end

  def archive
    project.update!(
      archived: true,
      archived_on: Time.current,
      manager: nil,
    )
  end

  def clear_todos
    project.todos.pending.destroy_all
  end

  def discard_milestones
    project.milestones.where(status: :progress).find_each do |milestone|
      milestone.comments.create!(
        user_id: actor.id,
        commentable_id: milestone.id,
        title: "Discarding as project has been archived.",
        status: "stale",
      )
      milestone.update!(status: "discarded")
    end
  end

  def submit_pending_reports
    project.reports.update_all(submitted: true)
  end

  def add_event
    project.events.create!(
      user: actor,
      action: "archived",
      action_for_context: "archived",
      trackable: project,
    )
  end

  def destroy_observers
    project.observers.destroy_all
  end
end
