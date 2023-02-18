class Report::CsvController < Report::BaseController
  include CsvHelper
  respond_to :csv

  def generate
    authorize :report, :generate?
    @data = JSON.parse(params[:data])
    @header = params[:header]
    if @header.split(" ").count == 3
      report = generate_csv_short(@data, header: @header)
    else
      report = generate_csv(@data, header: @header)
    end

    respond_to do |format|
      format.html
      format.csv { send_data report, type: "text/csv", filename: params[:title] + ".csv", disposition: "attachment" }
    end
  end
end
