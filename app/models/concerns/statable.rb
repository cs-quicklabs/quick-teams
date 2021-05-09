module Statable
  extend ActiveSupport::Concern

  def date_range(time_span)
    range, start_date, end_date = nil
    if time_span === "week"
      start_date = 6.days.ago.to_date
      end_date = Date.current
    elsif time_span === "month"
      start_date = 30.days.ago.to_date
      end_date = Date.current
    elsif time_span === "beginning"
      start_date = 1000.days.ago.to_date
      end_date = Date.current
    end

    (start_date..end_date)
  end

  def stats_title(time_span)
    title_message = ""
    start_date = date_range(time_span).first
    end_date = date_range(time_span).last
    if time_span === "week"
      title_message = "Last Week's Performance (#{start_date.to_s(:long)} to #{end_date.to_s(:long)})"
    elsif time_span === "month"
      title_message = "Last Month's Performance (#{start_date.to_s(:long)} to #{end_date.to_s(:long)})"
    elsif time_span === "beginning"
      title_message = "Performance Since Beginning"
    end
    title_message
  end
end
