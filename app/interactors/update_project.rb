class UpdateProject < Patterns::Service
  def initialize(project, params, observers)
    @project = project
    @params = params
    @observers = observers&.reject(&:blank?)
  end

  def call
    update_project
    update_observers
    project
  rescue StandardError
    project
  end

  private

  attr_reader :project, :observers, :params

  def update_project
    project.update!(params)
  end

  def update_observers
    project.observers.clear
    project.observers << User.where(id: observers) if observers.present?
  end
end
