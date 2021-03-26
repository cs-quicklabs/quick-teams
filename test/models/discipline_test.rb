require "test_helper"

class DisciplineTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
  end

  test "should have account" do
    ActsAsTenant.current_tenant = nil
    assert_raises ActsAsTenant::Errors::NoTenantSet do
      discipline = Discipline.new(name: "Discipline")
      discipline.save
    end
  end

  test "should have name" do
    discipline = Discipline.new
    discipline.valid?
    assert_not discipline.errors[:name].empty?
  end

  test "should have name unique to tenant" do
    discipline = Discipline.new(name: "Discipline")
    assert discipline.save!

    assert_raises ActiveRecord::RecordInvalid do
      discipline2 = Discipline.new(name: "Discipline")
      discipline2.save!
    end

    ActsAsTenant.current_tenant = accounts(:infosys)

    discipline3 = Discipline.new(name: "Discipline")
    assert discipline3.save!

    assert_raises ActiveRecord::RecordInvalid do
      discipline4 = Discipline.new(name: "Discipline")
      discipline4.save!
    end
  end
end
