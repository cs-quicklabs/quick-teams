require "test_helper"

class AddEmployeeReportTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @user = users(:regular)
    @params = { title: "some new report", body: "report body" }

    @actor = users(:actor)
  end

  test "can add report" do
    @submitted = true
    report = AddEmployeeReport.call(@user, @params, @submitted, @actor).result
    assert report
    assert_equal report.reportable_id, @user.id
    assert_equal report.submitted, @submitted
  end

  test "can add event report" do
    @submitted = true
    assert_difference("@user.events.count") do
      AddEmployeeReport.call(@user, @params, @submitted, @actor)
    end
    assert_equal Event.last.action, "report"
  end

  test "can draft report" do
    @submitted = false
    report = AddEmployeeReport.call(@user, @params, @submitted, @actor).result
    assert report
    assert_equal report.reportable_id, @user.id
    assert_equal report.submitted, @submitted
  end
end
