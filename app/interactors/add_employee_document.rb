class AddEmployeeDocument < Patterns::Service
  def initialize(employee, params, actor)
    @employee = employee
    @document = employee.documents.new(params)
    @actor = actor
  end

  def call
    add_document
    document
  rescue StandardError
    document
  end

  private

  attr_reader :employee, :document, :actor

  def add_document
    document.user_id = actor.id
    document.save!
  end
end
