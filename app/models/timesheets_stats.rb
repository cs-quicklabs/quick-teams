class TimesheetsStats
  attr_accessor :entries, :total_hours, :billable_hours, :billed_hours, :utilization

  def initialize(entries)
    @entries = entries
  end

  def total_hours
    entries.sum(:hours)
  end

  def billable_hours
    entries.where(billable: true).sum(:hours)
  end

  def billed_hours
    entries.where(billed: true).sum(:hours)
  end

  def utilization
    (billed_hours / total_hours) * 100
  end
end
