class ProjectPresenter
  def initialize(project)
    @project = project
  end

  def show_add_feedback_form
    !project.archived
  end

  def show_add_milestone_form
    !project.archived
  end

  private

  attr_accessor :project
end
