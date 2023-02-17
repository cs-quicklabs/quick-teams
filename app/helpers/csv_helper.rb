module CsvHelper
  def generate_csv(data, options = {})
    CSV.generate do |csv|
      # Write header row
      csv << options[:header].split(" ").collect { |x| x.to_s }
      ActiveRecord::Base.transaction do
        data = User.create(data)
        # Write data rows
        data.each do |row|
          row = row.decorate
          availability = row.overall_occupancy < 60 ? "Available at the moment" : row.display_occupied_till
          csv << [row.display_name, row.display_position, row.display_participated_projects, availability, row.display_occupancy, row.status.nil? ? "" : row.status.name]
        end
      end
    end
  end

  def generate_csv_short(data, options = {})
    CSV.generate do |csv|
      # Write header row
      csv << options[:header].split(" ").collect { |x| x.to_s }
      ActiveRecord::Base.transaction do
        data = User.create(data)
        # Write data rows
        data.each do |row|
          row = row.decorate
          availability = row.overall_occupancy < 60 ? "Available at the moment" : row.display_occupied_till
          csv << [row.display_name, row.display_position, row.status.nil? ? "" : row.status.name]
        end
      end
    end
  end
end
