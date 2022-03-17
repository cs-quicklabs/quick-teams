require "application_system_test_case"

class TicketStatusesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_ticket_statuses_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Ticket Statuses"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new ticket status" do
    visit page_url
    fill_in "Add New Status", with: "dispatched"
    click_on "Save"
    take_screenshot
    assert_text "Ticket status was created successfully"
    assert_selector "#ticket_status_name", text: ""
  end

  test "can not add an empty ticket status" do
    visit page_url
    click_on "Save"
    assert_selector "div#error_explanation", text: "Name can't be blank"
    take_screenshot
  end

  test "can not add a duplicate ticket status" do
    visit page_url
    fill_in "Add New Status", with: ticket_statuses(:one).name
    click_on "Save"
    take_screenshot
    assert_text "Name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_ticket_status_url(ticket_statuses(:one), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/main/turbo-frame/form/li")
  end

  test "can delete a ticket status" do
    visit page_url
    ticket_status = ticket_statuses(:two)
    assert_selector "li", text: ticket_status.name
    page.accept_confirm do
      find("li", text: ticket_status.name).click_on("Delete")
    end
    assert_no_selector "li", text: ticket_status.name
  end

  test "can edit ticket status" do
    visit page_url
    ticket_status = ticket_statuses(:one)
    assert_selector "li", text: ticket_status.name
    find("li", text: ticket_status.name).click_on("Edit")
    within "turbo-frame#ticket_status_#{ticket_status.id}" do
      fill_in "ticket_status_name", with: "Edited Name"
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
  end

  test "can not edit ticket status with existing name" do
    visit page_url
    ticket_status = ticket_statuses(:one)
    two = ticket_statuses(:two)
    assert_selector "li", text: ticket_status.name
    find("li", text: ticket_status.name).click_on("Edit")
    within "turbo-frame#ticket_status_#{ticket_status.id}" do
      fill_in "ticket_status_name", with: two.name
      click_on "Save"
      take_screenshot
      assert_text "Name has already been taken"
    end
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with Ticket Statuses selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "Ticket Statuses"
    end
  end
end
