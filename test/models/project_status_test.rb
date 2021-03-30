require "test_helper"

class ProjectStatusTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
  end

  test "should have account" do
    ActsAsTenant.current_tenant = nil
    assert_raises ActsAsTenant::Errors::NoTenantSet do
      project_status = ProjectStatus.new(name: "project_status")
      project_status.save
    end
  end

  test "should have name" do
    project_status = ProjectStatus.new
    project_status.valid?
    assert_not project_status.errors[:name].empty?
  end

  test "should have name unique to tenant" do
    project_status = ProjectStatus.new(name: "project_status")
    assert project_status.save!

    assert_raises ActiveRecord::RecordInvalid do
      project_status2 = ProjectStatus.new(name: "project_status")
      project_status2.save!
    end

    ActsAsTenant.current_tenant = accounts(:infosys)

    project_status3 = ProjectStatus.new(name: "project_status")
    assert project_status3.save!

    assert_raises ActiveRecord::RecordInvalid do
      project_status4 = ProjectStatus.new(name: "project_status")
      project_status4.save!
    end
  end
end
