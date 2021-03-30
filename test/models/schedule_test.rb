require "test_helper"

class ScheduleTest < ActiveSupport::TestCase
  setup do
    @user = users(:regular)
    @project = projects(:one)
  end

  test "should have occupancy between 0 to 100" do
    schedule = Schedule.new
    schedule.valid?
    assert_not schedule.errors[:occupancy].empty?

    schedule = Schedule.new(occupancy: 90)
    schedule.valid?
    assert_empty schedule.errors[:occupancy]

    schedule = Schedule.new(occupancy: -1)
    schedule.valid?
    assert_not schedule.errors[:occupancy].empty?

    schedule = Schedule.new(occupancy: 101)
    schedule.valid?
    assert_not schedule.errors[:occupancy].empty?
  end

  test "should have start and end date" do
    schedule = Schedule.new
    schedule.valid?
    assert_not schedule.errors[:starts_at].empty?
    assert_not schedule.errors[:ends_at].empty?
  end

  test "should not have end date in past of start date" do
    schedule = Schedule.new(starts_at: DateTime.now, ends_at: 7.days.from_now)
    schedule.valid?
    assert_empty schedule.errors[:ends_at]

    schedule = Schedule.new(ends_at: DateTime.now, starts_at: 7.days.from_now)
    schedule.valid?
    assert_not schedule.errors[:ends_at].empty?
  end

  test "should have user" do
    schedule = Schedule.new
    schedule.valid?
    assert_not schedule.errors[:user].empty?
  end

  test "should have project" do
    schedule = Schedule.new
    schedule.valid?
    assert_not schedule.errors[:project].empty?
  end

  test "update touches user" do
    updated_at = @user.updated_at
    schedule = Schedule.new(user: @user, project: @project, starts_at: Time.now, ends_at: Time.now, occupancy: 100)
    schedule.save!
    updated_at_touched = @user.updated_at
    assert_not_equal updated_at, updated_at_touched
  end

  test "update touches project" do
    updated_at = @project.updated_at
    schedule = Schedule.new(user: @user, project: @project, starts_at: Time.now, ends_at: Time.now, occupancy: 100)
    schedule.save!
    updated_at_touched = @project.updated_at
    assert_not_equal updated_at, updated_at_touched
  end
end
