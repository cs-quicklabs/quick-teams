module CsvHelper
  def generate_csv(data)
    CSV.generate do |csv|
      # Write header row
      csv << data.first.keys

      # Write data rows
      data.each do |row|
        csv << [row[:column1], row[:column2], row[:column3]]
      end
    end
  end
end
