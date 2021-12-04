class UpdateReport < Patterns::Service
  def initialize(report, params, param)
    @report = report
      @param= param
      @params = params
  end

  def call
   begin
      update_report
       
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

  attr_reader :report, :param, :params
end
