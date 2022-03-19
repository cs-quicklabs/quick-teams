require "application_system_test_case"

class TicketsTest < ApplicationSystemTestCase
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

  def tickets_page_url
    tickets_url(script_name: "/#{@account.id}", ticket_id: @ticket.id)
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
    find("tr", id: dom_id(@ticket)).click_link(@ticket.title)
    within "#ticket-header" do
      assert_text "Edit"
      assert_text "Delete"
    end
    take_screenshot
  end

  test "can create a new ticket" do
    visit page_url
    discipline=disciplines(:engineering)
    label=discipline.ticket_labels.first.name
    select discipline.name, from: "ticket_discipline_id"
    select label, from: "ticket_ticket_label_id"
    fill_in "ticket_title", with: "ticket"
    fill_in "ticket_description", with: "This is some ticket"
    click_on "Add Ticket"
    take_screenshot
    assert_selector "p.notice", text: "Ticket was created successfully."
  end

  test "can not create with empty Name Description discipline and label " do
    visit page_url
    assert_selector "h1", text: "Add New Ticket"
    click_on "Add Ticket"
    take_screenshot
    assert_selector "h1", text: "Add New Ticket"
  end

  test "can edit a ticket" do
    visit page_url
    label=@ticket.discipline.ticket_labels.first.name
    find("tr", id: dom_id(@ticket)).click_link(@ticket.title)
    within "#ticket-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Ticket"
    select label, from: "ticket_ticket_label_id"
    fill_in "ticket_title", with: "ticket"
    fill_in "ticket_description", with: "This is some ticket"
    click_on "Save"
    assert_selector "p.notice", text: "Ticket was updated successfully."
  end

  test "can not edit a ticket with invalid name" do
    visit page_url
    find("tr", id: dom_id(@ticket)).click_link(@ticket.title)
    within "#ticket-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Ticket"
    fill_in "ticket_title", with: ""
    click_on "Save"
    take_screenshot
  end

  test "can delete ticket" do
    visit page_url
    find("tr", id: dom_id(@ticket)).click_link(@ticket.title)
    within "#ticket-header" do
      page.accept_confirm do
        click_on "Delete"
      end
    end
    take_screenshot
    assert_selector "p.notice", text: "Ticket was removed successfully."
  end
end
