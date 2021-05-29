class EmployeesStats
  attr_accessor :entries, :total, :billable

  def initialize(entries)
    @entries = entries
  end

  def total
    entries.size
  end

  def billable
    entries.where(billable: true).count
  end
end
