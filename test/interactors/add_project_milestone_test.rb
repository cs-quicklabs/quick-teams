require "test_helper"

class AddProjectMilestoneTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @project = projects(:one)
    @params = { title: "Milestone title", deadline: "2021-04-01", body: "Milestone Body" }
    @actor = users(:actor)
  end

  test "can add milestone" do
    milestone = AddProjectMilestone.call(@project, @params, @actor).result
    assert milestone
    assert_equal milestone.user_id, @actor.id
  end

  test "can add event milestone" do
    assert_difference("@project.events.count") do
      AddProjectMilestone.call(@project, @params, @actor)
    end
    assert_equal Event.last.action, "milestone"
  end
end
