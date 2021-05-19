class GoalsStats
  attr_accessor :entries, :total, :missed, :completed, :progress, :discarded

  def initialize(entries)
    @entries = entries
  end

  def total
    entries.size
  end

  def missed
    entries.where(status: :missed).size
  end

  def completed
    entries.where(status: :completed).size
  end

  def progress
    entries.where(status: :progress).size
  end

  def discarded
    entries.where(status: :discarded).size
  end
end
