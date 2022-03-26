require "application_system_test_case"

class TodosTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_tags_url(script_name: "/#{@account.id}")
  end

  test "can delete a tag" do
    visit page_url
    tag = tags(:one)

    assert_selector "li", text: tag.name
    page.accept_confirm do
      find("li", text: tag.name).click_on("Delete")
    end
    assert_no_selector "li", text: tag.name
  end
end
