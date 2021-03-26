require "test_helper"

class PeopleStatusTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
  end

  test "should have account" do
    ActsAsTenant.current_tenant = nil
    assert_raises ActsAsTenant::Errors::NoTenantSet do
      people_status = PeopleStatus.new(name: "people_status")
      people_status.save
    end
  end

  test "should have name" do
    people_status = PeopleStatus.new
    people_status.valid?
    assert_not people_status.errors[:name].empty?
  end

  test "should have name unique to tenant" do
    people_status = PeopleStatus.new(name: "people_status")
    assert people_status.save!

    assert_raises ActiveRecord::RecordInvalid do
      people_status2 = PeopleStatus.new(name: "people_status")
      people_status2.save!
    end

    ActsAsTenant.current_tenant = accounts(:infosys)

    people_status3 = PeopleStatus.new(name: "people_status")
    assert people_status3.save!

    assert_raises ActiveRecord::RecordInvalid do
      people_status4 = PeopleStatus.new(name: "people_status")
      people_status4.save!
    end
  end
end
