class UpdateProject < Patterns::Service
  def initialize(project, params, observers)
    @project = project
    @params = params
    @observers = observers.reject(&:blank?)
  end

  def call
    begin
      update_project
      add_observers
    rescue
      project
    end
    project
  end

  def update_project
    @project.update(@params)
  end

  def add_observers
    new_observers = observers - project.observers

    project.observers << User.where("id in (?)", new_observers)
    project.observers.delete(project.observers.pluck(:id) - observers)
  end

  attr_reader :project, :observers, :params
end
