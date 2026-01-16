class JobCard < ApplicationRecord
  belongs_to :user, optional: true

  enum :session,  morning: 0, afternoon: 1, evening: 2
  enum :color, { gray: 0, green: 1, yellow: 2, blue: 3, red: 4 } 

  validates :title, presence: true, length: { maximum: 255 }
  validates :date, :session, :slot_start, :slot_length, presence: true
  validates :slot_start, inclusion: { in: 1..9 }
  validates :slot_length, inclusion: { in: 1..9 }
  validate :slot_end_within_session
  
  # Set default color to gray
  after_initialize :set_default_color

  scope :for_date, ->(date) { where(date: date) }
  scope :for_week, ->(start_date) { where(date: start_date..(start_date + 6.days)) }

  def slot_end
    slot_start + slot_length - 1
  end

  def height_rem
    slot_length * 2.5
  end

  def color_class
    case color
    when 'green'
      'bg-green-500'
    when 'yellow'
      'bg-yellow-500'
    when 'blue'
      'bg-blue-500'
    when 'red'
      'bg-red-500'
    else # gray or nil
      'bg-gray-500'
    end
  end

  def weekly_color_class
    case color
    when 'green'
      'bg-green-400'
    when 'yellow'
      'bg-yellow-400'
    when 'blue'
      'bg-blue-400'
    when 'red'
      'bg-red-400'
    else # gray or nil
      'bg-gray-400'
    end
  end

  private

  def slot_end_within_session
    if slot_start && slot_length && (slot_start + slot_length - 1) > 9
      errors.add(:slot_length, "extends beyond session (max slot is 9)")
    end
  end

  def set_default_color
    self.color ||= 'gray'
  end
end
