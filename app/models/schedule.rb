class Schedule < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :project, touch: true

  validates_presence_of :user, :starts_at, :ends_at, :project, :occupancy
  validates_numericality_of :occupancy

  validates :occupancy, inclusion: { in: 0..100, message: "should be less than equal to 100%" }
  validate :end_date_cannot_be_in_the_past

  def end_date_cannot_be_in_the_past
    return if ends_at.blank? || starts_at.blank?

    if ends_at < starts_at
      errors.add(:ends_at, "cannot be before the start date")
    end
  end
  validates :billable, inclusion: { in: [true, false]}
  SCHEDULE_OPTIONS = [
    ['Billable', 'true'], 
    ['Non-billable','false']
  ]
end
