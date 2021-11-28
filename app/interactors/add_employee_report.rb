class AddEmployeeReport < Patterns::Service
  def initialize(employee, params, param, actor)
   @employee = employee
    @report = @employee.reports.new params
     @param= param
     @actor = actor
  end

  def call
   
      add_report
      add_event
       begin
    rescue
      report
    end

    report
  end
 
  private

  def add_report
      if param[:draft]
         report.submitted = false
      else
    report.submitted = true
    end
    report.save!
  end
  
  def add_event
    employee.events.create(user: actor, action: "report", action_for_context: "added new report in employee", trackable: report)
  end

  attr_reader :employee, :report, :param, :actor
end
