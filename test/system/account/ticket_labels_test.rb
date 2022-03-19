require "application_system_test_case"

class TicketLabelsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_ticket_labels_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Ticket Labels"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new ticket label" do
    visit page_url
    name = "#{disciplines(:one).name}"
    assignee = "#{users(:actor).name}"
    fill_in "Add New label", with: "Initiated"
    select name, from: "ticket_label_discipline_id"
    select assignee, from: "ticket_label_user_id"
    click_on "Save"
    take_screenshot
    assert_text "Ticket label was created successfully"
    assert_selector "#ticket_label_name", text: ""
  end

  test "can not add an empty ticket label" do
    visit page_url
    click_on "Save"
    assert_selector "div#error_explanation", text: "Name can't be blank"
    take_screenshot
  end

  test "can visit edit page" do
    visit edit_account_ticket_label_url(ticket_labels(:one), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/main/turbo-frame/form/div")
  end

  test "can delete a ticket label" do
    visit page_url
    ticket_label = ticket_labels(:one)
    assert_selector "li", text: ticket_label.name
    page.accept_confirm do
      find("li", text: ticket_label.name).click_on("Delete")
    end
    assert_no_selector "li", text: ticket_label.name
  end

  test "can edit ticket label" do
    visit page_url
    ticket_label = ticket_labels(:one)
    assert_selector "li", text: ticket_label.name
    find("li", text: ticket_label.name).click_on("Edit")
    within "turbo-frame#ticket_label_#{ticket_label.id}" do
      fill_in "ticket_label_name", with: "Edited Name"
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
  end



  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with Ticket Labels selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "Ticket Labels"
    end
  end
end
