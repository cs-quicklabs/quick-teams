class Report::CsvController < Report::BaseController
  include CsvHelper
  respond_to :csv

  def generate
    authorize :report, :generate?
    @data = JSON.parse(params[:data])
    @header = params[:header]
    report = generate_csv(@data, header: @header)

    respond_to do |format|
      format.html
      format.csv { send_data report, type: "text/csv", filename: "report.csv", disposition: "attachment" }
    end
  end

  def generate_csv_short
    authorize :report, :generate?
    @data = JSON.parse(params[:data])
    @header = params[:header]
    report = generate_csv_short(@data, header: @header)

    respond_to do |format|
      format.html
      format.csv { send_data report, type: "text/csv", filename: "report.csv", disposition: "attachment" }
    end
  end
end
