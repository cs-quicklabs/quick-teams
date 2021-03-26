require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "should have name" do
    account = Account.new(name: nil)
    account.valid?
    assert_not account.errors[:name].empty?
  end
end
