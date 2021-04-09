class ScheduleDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :project

  def display_occupancy
    "#{occupancy}% occupied"
  end

  def display_occupied_till
    "till #{ends_at.to_s(:long)}"
  end
end
