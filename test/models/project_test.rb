require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  setup do
    @current_account = accounts(:crownstack)
    @project = projects(:one)
    ActsAsTenant.current_tenant = @current_account
  end

  test "should not require manager" do
    project = Project.new
    project.valid?
    assert_empty project.errors[:manager]
  end

  test "should have name" do
    project = Project.new
    project.valid?
    assert_not project.errors[:name].empty?
  end

  test "should have discipline" do
    project = Project.new
    project.valid?
    assert_not project.errors[:discipline].empty?
  end

  test "should not have inactive users in potential participants" do
    potential_participants = @project.potential_participants
    potential_participants.each do |participant|
      assert participant.active
    end
  end

  test "should not have existing participants in potential participants" do
    potential_participants = @project.potential_participants
    project_participants = @project.participants
    assert (potential_participants & project_participants).length == 0
  end

  test "should have potential participants from current account" do
    potential_participants = @project.potential_participants
    potential_participants.each do |participant|
      assert_equal participant.account, @current_account
    end
  end

  test "should not have active project in archived ones" do
    projects = Project.archived
    projects.each do |project|
      assert project.archived
    end
  end

  test "should not have archived projects in active ones" do
    projects = Project.active
    projects.each do |project|
      assert_not project.archived
    end
  end
end
