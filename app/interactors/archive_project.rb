class ArchiveProject < Patterns::Service
  def initialize(project, actor)
    @project = project
    @actor = actor
  end

  def call
    begin
      clear_schedule
      clear_todos
      discard_milestones
      archive
      add_event    
    rescue
      project
    end

    project
  end

  private

  def clear_schedule
    project.schedules.destroy_all
  end

  def archive
    project.archived = true
    project.archived_on = DateTime.now.utc
    project.manager = nil
    project.save!
  end

  def clear_todos
    project.todos.pending.destroy_all
  end

  def discard_milestones
    project.milestones.where(status: :progress).each do |goal|
      params = { user_id: actor.id, goal_id: goal.id, title: "Discarding as project has been archived.", status: "stale" }
      goal.comments <<  Comment.new(params)
      goal.update_attribute("status", "discarded")
    end
  end


  def add_event
    project.events.create(user: actor, action: "archived", action_for_context: "archived", trackable: project)
  end

  attr_reader :project, :actor
end
