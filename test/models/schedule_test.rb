require "test_helper"

class ScheduleTest < ActiveSupport::TestCase
  setup do
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
  end

  test "should have start date lesser than end date" do
  end

  test "should have user" do
  end

  test "should have project" do
  end

  test "update touches user" do
  end

  test "update touches project" do
  end
end
