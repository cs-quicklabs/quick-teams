class UpdateProject < Patterns::Service
  def initialize(project, params, observers)
    @project = project
    @params = params
    @observers = observers.reject(&:blank?).map(&:to_i)
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
    new_observers = observers - project.observers.pluck(:id)
    project.observers << User.where("id IN (?)", new_observers)
    project.observers.destroy(project.observers.pluck(:id).uniq - observers)
  end

  attr_reader :project, :observers, :params
end
