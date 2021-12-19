class UpdateReport < Patterns::Service
  def initialize(report, params, param)
    @report = report
    @param = param
    @params = params
    @reportable = @report.reportable
    @actor = @report.user
  end

  def call
    begin
      if param[:draft]
        update_report
      else
        update_report
        add_event
      end
    rescue
      report
    end

    report
  end

  private

  def update_report
    if param[:draft]
      report.update(params)
    else
      report.assign_attributes(submitted: true)
      report.update(params)
    end
  end

  def add_event
    reportable.events.create(user: actor, action: "report", action_for_context: "added new report in project", trackable: report)
  end

  attr_reader :report, :param, :params, :actor, :reportable
end
