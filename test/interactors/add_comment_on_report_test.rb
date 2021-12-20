require "test_helper"

class AddCommentonReportTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @user = users(:regular)
    @report = @user.reports.first
    @actor = users(:actor)
    @params = { user_id: @actor.id, commentable_id: @report.id, title: "this is a new report", status: "stale" }
  end

  test "can comment on goal" do
    comment = AddCommentOnReport.call(@params, @report, @actor).result
    assert comment
    assert_equal comment.user_id, @actor.id
  end
end
