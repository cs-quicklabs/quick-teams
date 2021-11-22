require "application_system_test_case"

class AccountMiddlewaresTest < ApplicationSystemTestCase
  setup do
    @account = accounts(:crownstack)
    sign_in users(:regular)
  end

  test "loads projects correctly" do
    visit projects_url(script_name: "/#{@account.id}")
    assert_selector "h1", text: "Projects"
  end

  test "cannot find the account redirects to main page" do    
    visit projects_url(script_name: "/123456789")
    assert_equal current_path, "/#{@account.id}/home"
  end
end
