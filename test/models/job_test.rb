require "test_helper"

class JobTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
  end

  test "should have account" do
    ActsAsTenant.current_tenant = nil
    assert_raises ActsAsTenant::Errors::NoTenantSet do
      job = Job.new(name: "Job")
      job.save
    end
  end

  test "should have name" do
    job = Job.new
    job.valid?
    assert_not job.errors[:name].empty?
  end

  test "should have name unique to tenant" do
    job = Job.new(name: "job")
    assert job.save!

    assert_raises ActiveRecord::RecordInvalid do
      job2 = Job.new(name: "job")
      job2.save!
    end

    ActsAsTenant.current_tenant = accounts(:infosys)

    job3 = Job.new(name: "job")
    assert job3.save!

    assert_raises ActiveRecord::RecordInvalid do
      job4 = Job.new(name: "job")
      job4.save!
    end
  end
end
