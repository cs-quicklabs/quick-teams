class UpdateEventsNature < ActiveRecord::Migration[6.1]
  def change
    ActsAsTenant.current_tenant = Account.find(1)
    events = Event.where(trackable_type: "Schedule")
    events.each do |event|
      event.destroy if event.trackable.nil?
    end
    events = Event.where(trackable_type: "Schedule")
    events.each do |event|
      event.update(trackable_type: "User", trackable_id: event.trackable.user.id)
    end
  end
end
