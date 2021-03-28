require "application_system_test_case"

class AccountDisciplinesTest < ApplicationSystemTestCase
  setup do
    @account = accounts(:crownstack)
    sign_in users(:regular)
  end

  test "visiting the index" do
    visit account_disciplines_url(script_name: "/#{@account.id}")

    assert_selector "h1", text: "Disciplines"
  end
end
