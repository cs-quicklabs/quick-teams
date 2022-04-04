require "application_system_test_case"

class TicketsTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @ticket = @user.tickets.first
    sign_in @user
  end

  def page_url
    tickets_url(script_name: "/#{@account.id}")
  end

  def ticket_detail_page_url
    ticket_url(script_name: "/#{@account.id}", id: @ticket.id)
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Tickets"
    assert_selector "form#new_ticket"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can show ticket detail page" do
    visit page_url
    find("tr", id: dom_id(@ticket)).click_link(@ticket.description)
    within "#ticket-header" do
      assert_text "Edit"
      assert_text "Delete"
    end
    take_screenshot
  end

  test "can create a new ticket if label exist" do
    visit page_url
    if TicketLabel.all.count > 0
      label = TicketLabel.where(account: @account).first.name
      select label, from: "ticket_ticket_label_id"
      fill_in "ticket_description", with: "This is some ticket"
      assert_emails 1 do
        click_on "Add Ticket"
        sleep(0.5)
      end
      take_screenshot
      assert_selector "p.notice", text: "Ticket was created successfully."
    else
      assert_text "Please add Ticket Label"
    end
  end

  test "can not create with empty Description and label " do
    visit page_url
    assert_selector "h1", text: "Add New Ticket"
    click_on "Add Ticket"
    take_screenshot
    assert_selector "h1", text: "Add New Ticket"
    assert_selector "div#error_explanation", text: "Ticket label must exist"
    assert_selector "div#error_explanation", text: "Description can't be blank"
  end

  test "can edit a ticket" do
    visit page_url
    find("tr", id: dom_id(@ticket)).click_link(@ticket.description)
    within "#ticket-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Ticket"
    fill_in "ticket_description", with: "This is some ticket"
    click_on "Save"
    assert_selector "p.notice", text: "Ticket was updated successfully."
  end

  test "can not edit a ticket with invalid description" do
    visit page_url
    find("tr", id: dom_id(@ticket)).click_link(@ticket.description)
    within "#ticket-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Ticket"
    fill_in "ticket_description", with: ""
    click_on "Save"
    assert_selector "h1", text: "Edit Ticket"
    assert_selector "div#error_explanation", text: "Description can't be blank"
    take_screenshot
  end

  test "can delete ticket" do
    visit page_url
    find("tr", id: dom_id(@ticket)).click_link(@ticket.description)
    within "#ticket-header" do
      page.accept_confirm do
        click_on "Delete"
      end
    end
    take_screenshot
    assert_selector "p.notice", text: "Ticket was removed successfully."
  end

  test "can comment on ticket" do
    sign_out @user
    @employee= @ticket.ticket_label.user
    sign_in @employee
    visit ticket_detail_page_url
    fill_in "comment", with: "This is a comment"
    assert_emails 1 do
      click_on "Comment"
      sleep(0.5)
    end
    assert_selector "ul#comments", text: "This is a comment"
    assert_text "Edit"
    assert_text "Delete"
    take_screenshot
  end

  test "can complete ticket" do
    visit page_url
    ticket = @user.tickets.first
    find("tr", id: dom_id(ticket)).click_link(ticket.description)
    fill_in "comment", with: "This is completed"
    click_on "option-menu-button"
    click_on "and mark Completed"
    assert_selector "ul#comments", text: "This is completed"
    assert_selector "p", text: "This ticket was marked as complete."
    take_screenshot
  end

end
