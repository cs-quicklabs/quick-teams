require "test_helper"

class AddprojectReportTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @project = projects(:one)
    @params = { title: "some new report", body: "report body" }
    @actor = users(:actor)
  end

  test "can add report" do
    @submitted = true
    report = AddProjectReport.call(@project, @params, @submitted, @actor).result
    assert report
    assert_equal report.reportable_id, @project.id
    assert_equal report.user_id, @actor.id
    assert_equal report.submitted, @submitted
  end

  test "can add event report" do
    @submitted = true
    assert_difference("@project.events.count") do
      AddProjectReport.call(@project, @params, @submitted, @actor)
    end
    assert_equal Event.last.action, "report"
  end

  test "can draft report" do
    @submitted = false
    report = AddProjectReport.call(@project, @params, @submitted, @actor).result
    assert report
    assert_equal report.reportable_id, @project.id
    assert_equal report.user_id, @actor.id
    assert_equal report.submitted, @submitted
  end
end
