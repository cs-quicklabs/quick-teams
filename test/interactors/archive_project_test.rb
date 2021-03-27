require "test_helper"

class ArchiveProjectTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @project = projects(:unarchived)
    @actor = users(:actor)
  end

  test "can archive project" do
    project = ArchiveProject.call(@project, @actor).result
    assert project
    assert project.archived
    assert_not_nil project.archived_on
    assert_nil project.manager
  end

  test "can add event archived" do
    assert_difference("@project.events.count") do
      ArchiveProject.call(@project, @actor)
    end
    assert_equal Event.last.action, "archived"
  end

  test "can clear schedules" do
    project = ArchiveProject.call(@project, @actor).result
    assert project.schedules.count == 0
  end
end
