require "application_system_test_case"

class QuestionCategroiesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_question_categories_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Survey Question Categories"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new question category" do
    visit page_url
    fill_in "Add New Category", with: "question category"
    click_on "Save"
    take_screenshot
    assert_text "Survey question category was created successfully"
    assert_selector "#survey_question_category_name", text: ""
  end

  test "can not add an empty question category" do
    visit page_url
    click_on "Save"
    assert_selector "div#error_explanation", text: "Name can't be blank"
    take_screenshot
  end

  test "can not add a duplicate question category" do
    visit page_url
    fill_in "Add New Category", with: survey_question_categories(:one).name
    click_on "Save"
    take_screenshot
    assert_text "Name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_question_category_url(survey_question_categories(:one), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/turbo-frame/form/li")
  end

  test "can delete a question category" do
    visit page_url
    question_category = survey_question_categories(:one)
    assert_selector "li", text: question_category.name
    find("li", text: question_category.name).click_on("Delete")
    assert_no_selector "li", text: question_category.name
  end

  test "can edit question category" do
    visit page_url
    question_category = survey_question_categories(:one)
    assert_selector "li", text: question_category.name
    find("li", text: question_category.name).click_on("Edit")
    within "turbo-frame#survey_question_category_#{question_category.id}" do
      fill_in "survey_question_category_name", with: "Edited Name"
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
  end

  test "can not edit question category with existing name" do
    visit page_url
    question_category = survey_question_categories(:one)
    two = survey_question_categories(:two)
    assert_selector "li", text: question_category.name
    find("li", text: question_category.name).click_on("Edit")
    within "turbo-frame#survey_question_category_#{question_category.id}" do
      fill_in "survey_question_category_name", with: two.name
      click_on "Save"
      take_screenshot
      assert_text "Name has already been taken"
    end
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with Question Categories selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "Question Categories"
    end
  end
end
