class UnarchiveProject < Patterns::Service
  def initialize(project)
    @project = project
  end

  def call
    project.archived = false
    project.archived_on = nil
    project.save
    project
  end

  private

  attr_reader :project
end
