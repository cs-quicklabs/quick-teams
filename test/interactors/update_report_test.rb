require "test_helper"

class UpdateReportTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)

    @project = projects(:one)
    @report = @project.reports.first
    @employee = users(:regular)
    @actor = users(:actor)
    @params = { title: "some new report", body: "report body" }
  end

  test "can update report" do
    @submitted = false
    report = UpdateReport.call(@report, @params, @submitted).result
    assert report
    assert_equal report.reportable, @project
    assert_equal report.submitted, @submitted
  end
  test "can update and submit report" do
    @submitted = true
    report = UpdateReport.call(@report, @params, @submitted).result
    assert report
    assert_equal report.reportable, @project
    assert_equal report.submitted, @submitted
  end
end
