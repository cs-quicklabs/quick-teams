require "test_helper"

class ProjectTagTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
  end

  test "should have account" do
    ActsAsTenant.current_tenant = nil
    assert_raises ActsAsTenant::Errors::NoTenantSet do
      project_tag = ProjectTag.new(name: "project_tag")
      project_tag.save
    end
  end

  test "should have name" do
    project_tag = ProjectTag.new
    project_tag.save
    assert_not project_tag.errors[:name].empty?
  end

  test "should have name unique to tenant" do
    project_tag = ProjectTag.new(name: "project_tag")
    assert project_tag.save!

    assert_raises ActiveRecord::RecordInvalid do
      project_tag2 = ProjectTag.new(name: "project_tag")
      project_tag2.save!
    end

    ActsAsTenant.current_tenant = accounts(:infosys)

    project_tag3 = ProjectTag.new(name: "project_tag")
    assert project_tag3.save!

    assert_raises ActiveRecord::RecordInvalid do
      project_tag4 = ProjectTag.new(name: "project_tag")
      project_tag4.save!
    end
  end
end
