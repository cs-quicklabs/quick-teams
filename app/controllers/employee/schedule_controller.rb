class Employee::ScheduleController < Employee::BaseController
	def index
		collection = Schedule.where(employee: @employee).includes({ project: [:discipline] })
		@schedules = ScheduleDecorator.decorate_collection(collection)
		@schedule = Schedule.new
	end
end