class ScheduleDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :project

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def display_occupancy
    "#{occupancy}% occupied"
  end

  def display_occupied_till
    "till #{ends_at.to_s(:long)}"
  end
end
