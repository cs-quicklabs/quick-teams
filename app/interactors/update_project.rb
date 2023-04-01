class UpdateProject < Patterns::Service
  def initialize(project, params, observers)
    @project = project
    @params = params
    @observers = observers.reject(&:blank?) if observers
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
    project.observers.clear
    project.observers << User.where("id IN (?)", observers) unless observers.blank?
  end

  attr_reader :project, :observers, :params
end
