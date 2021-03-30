require "test_helper"

class RoleTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
  end

  test "should have account" do
    ActsAsTenant.current_tenant = nil
    assert_raises ActsAsTenant::Errors::NoTenantSet do
      role = Role.new(name: "role")
      role.save
    end
  end

  test "should have name" do
    role = Role.new
    role.valid?
    assert_not role.errors[:name].empty?
  end

  test "should have name unique to tenant" do
    role = Role.new(name: "role")
    assert role.save!

    assert_raises ActiveRecord::RecordInvalid do
      role2 = Role.new(name: "role")
      role2.save!
    end

    ActsAsTenant.current_tenant = accounts(:infosys)

    role3 = Role.new(name: "role")
    assert role3.save!

    assert_raises ActiveRecord::RecordInvalid do
      role4 = Role.new(name: "role")
      role4.save!
    end
  end
end
