class ParticipantForm
	include ActiveModel::Model

	validates_presence_of :starts_at, :ends_at, :occupancy, :user, :project
	validate :starts_at_cannot_be_in_the_past, :ends_at_cannot_be_in_the_past
	validates :occupancy, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

	attr_accessor :user, :starts_at, :ends_at, :occupancy, :project

	def initialize(project,schedule)
	@schedule = schedule
	@project = project
	end

	def submit (params)
		self.user = params[:user_id]
		self.starts_at = params[:starts_at]
		self.ends_at = params[:ends_at]
		self.occupancy = params[:occupancy]

		if valid?
			@schedule.update(params)
			@schedule.project = @project
			@schedule.save!
			true
		else
			false
		end
	end

	def persisted?
    	false
  	end

	def starts_at_cannot_be_in_the_past
		if starts_at.present? && starts_at < Date.today
			errors.add(:starts_at, "can't be in the past")
		end
	end
	
	def ends_at_cannot_be_in_the_past
		if ends_at.present? && ends_at < Date.today
			errors.add(:ends_at, "can't be in the past")
		end
	end
end