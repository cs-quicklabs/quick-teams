require "application_system_test_case"

class NuggetsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @nugget = @user.nuggets.first
    sign_in @user
  end

  def page_url
    nuggets_url(script_name: "/#{@account.id}")
  end

  def project_page_url
    nugget_url(script_name: "/#{@account.id}", nugget_id: @nugget.id)
  end

  test "admin can see nuggets" do
  end

  test "lead can see nuggets created by him" do
  end

  test "member can not see nuggets" do
  end

  test "admin can add nugget" do
  end

  test "lead can add nugget" do
  end

  test "member can not add nugget" do
  end

  test "admin can edit unpublished nugget" do
  end

  test "lead can edit unpublished nugget create by him" do
  end

  test "member can not edit nuggets" do
  end

  test "admin can delete any nugget" do
  end

  test "lead can delete unpublished nugget created by him" do
  end

  test "member can not delete nugget" do
  end

  test "admin can publish a nugget" do
  end

  test "lead can not publish a nugget" do
  end

  test "member can not publish a nugget" do
  end
end
