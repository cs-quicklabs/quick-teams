require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @report = reports(:one)
    @goal = goals(:one)
    sign_in @employee
  end

  def report_url
    employee_report_url(script_name: "/#{@account.id}", employee_id: @report.reportable.id, id: @report.id)
  end

  def goal_url
    employee_goal_url(script_name: "/#{@account.id}", employee_id: @goal.goalable.id, id: @goal.id)
  end

  test "can edit comment on goal" do
    visit goal_url
    take_screenshot
    assert_selector "h3", text: @goal.title
    fill_in "comment", with: "This is a comment"
    click_on "Comment"
    assert_selector "p", text: "This is a comment"
    within "#comments" do
      click_on "Edit"
      fill_in "comment", with: "This is an edited comment"
      click_on "Comment"
    end

    assert_selector "p", text: "This is an edited comment"
  end

  test "can delete comment on goal" do
    visit goal_url
    take_screenshot
    assert_selector "h3", text: @goal.title
    fill_in "comment", with: "This is a comment"
    click_on "Comment"
    assert_selector "p", text: "This is a comment"
    within "#comments" do
      page.accept_confirm do
        click_on "Delete"
      end
    end
    assert_no_text "This is a comment"
  end

  test "can edit comment on report" do
    visit report_url
    take_screenshot
    assert_selector "h3", text: @report.title
    fill_in "comment", with: "This is a comment"
    click_on "Comment"
    assert_selector "p", text: "This is a comment"
    within "#comments" do
      click_on "Edit"
      fill_in "comment", with: "This is an edited comment"
      click_on "Comment"
    end

    assert_selector "p", text: "This is an edited comment"
  end

  test "can delete comment on report" do
    visit report_url
    take_screenshot
    assert_selector "h3", text: @report.title
    fill_in "comment", with: "This is a comment"
    click_on "Comment"
    assert_selector "p", text: "This is a comment"
    within "#comments" do
      page.accept_confirm do
        click_on "Delete"
      end
    end
    assert_no_text "This is a comment"
  end
end
