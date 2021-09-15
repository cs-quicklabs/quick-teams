require "test_helper"

class SurveyTest < ActiveSupport::TestCase
  setup do
    @current_account = accounts(:crownstack)
    @survey = surveys(:one)
    ActsAsTenant.current_tenant = @current_account
  end

  test "should have account" do
    ActsAsTenant.current_tenant = nil
    assert_raises ActsAsTenant::Errors::NoTenantSet do
      Survey = Survey.new(name: "survey")
      Survey.save
    end
  end

  test "should have name" do
    survey = Survey.new
    survey.save
    assert_not survey.errors[:name].empty?
  end

  test "should have name unique to tenant" do
    survey = Survey.new(name: "")
    assert Survey.save!

    assert_raises ActiveRecord::RecordInvalid do
      Survey2 = Survey.new(name: "Survey")
      Survey2.save!
    end

    ActsAsTenant.current_tenant = accounts(:infosys)

    Survey3 = Survey.new(name: "Survey")
    assert Survey3.save!

    assert_raises ActiveRecord::RecordInvalid do
      Survey4 = Survey.new(name: "Survey")
      Survey4.save!
    end
  end
end
