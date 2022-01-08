class DestroyProject < Patterns::Service
  def initialize(project)
    @project = project
  end

  def call
    begin
      project.destroy
    rescue
      return false
    end
    true
  end

  private

  attr_reader :project
end
