class AddEmployeeDocument < Patterns::Service
  def initialize(employee, params, actor)
    @employee = employee
    @document = @employee.documents.new params
    @actor = actor
  end

  def call
    begin
      add_document
      add_event
    rescue
      document
    end

    document
  end

  private

  def add_document
    document.user_id = actor.id
    document.save!
  end

  def add_event
    employee.events.create(user: actor, action: "document", action_for_context: "added new document in employee", trackable: document)
  end

  attr_reader :employee, :document, :actor
end
