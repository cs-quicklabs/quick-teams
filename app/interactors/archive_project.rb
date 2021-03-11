class ArchiveProject < Patterns::Service
  def initialize(project)
    @project = project
  end

  def call
    project.schedules.destroy_all
    project.archived = true
    project.archived_on = Time.now
    project.save
    project
  end

  private

  attr_reader :project
end
