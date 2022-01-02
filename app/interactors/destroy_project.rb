class DestroyProject < Patterns::Service
  def initialize(project)
    @project = project
  end

  def call
    project.destroy
    false
  end

  private

  attr_reader :project
end
