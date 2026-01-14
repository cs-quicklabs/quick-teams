class JobCard < ApplicationRecord
  belongs_to :user, optional: true

  enum :session,  morning: 0, afternoon: 1, evening: 2 

  validates :title, presence: true, length: { maximum: 255 }
  validates :date, :session, :slot_start, :slot_length, presence: true
  validates :slot_start, inclusion: { in: 1..9 }
  validates :slot_length, inclusion: { in: 1..9 }
  validate :slot_end_within_session

  scope :for_date, ->(date) { where(date: date) }
  scope :for_week, ->(start_date) { where(date: start_date..(start_date + 6.days)) }

  def slot_end
    slot_start + slot_length - 1
  end

  def height_rem
    slot_length * 2.5
  end

  private

  def slot_end_within_session
    if slot_start && slot_length && (slot_start + slot_length - 1) > 9
      errors.add(:slot_length, "extends beyond session (max slot is 9)")
    end
  end
end
