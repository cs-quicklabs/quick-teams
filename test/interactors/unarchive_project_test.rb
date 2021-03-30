require "test_helper"

class UnarchiveProjectTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @project = projects(:archived)
    @actor = users(:actor)
  end

  test "can archive project" do
    project = UnarchiveProject.call(@project, @actor).result
    assert project
    assert_not project.archived
    assert_nil project.archived_on
  end

  test "can add event unarchived" do
    assert_difference("@project.events.count") do
      UnarchiveProject.call(@project, @actor)
    end
    assert_equal Event.last.action, "unarchived"
  end
end
