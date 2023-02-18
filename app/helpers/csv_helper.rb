module CsvHelper
  def to_csv(data)
    CSV.generate do |csv|
      # Write header row
      csv << ["Name", "Role", "Projects", "Occupancy", "Availability", "Status"]
      # Write data rows
      data.each do |row|
        row = row.decorate
        availability = row.overall_occupancy < 60 ? "Available at the moment" : row.display_occupied_till
        csv << [row.display_name, row.display_position, row.display_participated_projects, availability, row.display_occupancy, row.status.nil? ? "" : row.status.name]
      end
    end
  end

  def to_csv_short(data)
    CSV.generate do |csv|
      # Write header row
      csv << ["Name", "Role", "Status"]
      data.each do |row|
        row = row.decorate
        availability = row.overall_occupancy < 60 ? "Available at the moment" : row.display_occupied_till
        csv << [row.display_name, row.display_position, row.status.nil? ? "" : row.status.name]
      end
    end
  end
end
