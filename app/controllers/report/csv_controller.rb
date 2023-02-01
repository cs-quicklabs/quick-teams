class CsvController < BaseController
  include CsvHelper

  def generate
    @data = # data to be written to the CSV file
      csv_data = generate_csv(@data)

    send_data csv_data,
      type: "text/csv",
      filename: "report.csv",
      disposition: "attachment"
  end
end
