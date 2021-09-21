require "application_system_test_case"

class ReportsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @survey = survey_surveys(:one)
    sign_in @user
  end

  def page_url
    survey_questions_url(script_name: "/#{@account.id}", survey_id: @survey.id)
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: @survey.name
    assert_selector "div#survey-tabs", text: "Questions"
    assert_selector "form#new_survey_question"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new question" do
    visit page_url
    fill_in "survey_question_text", with: "This is a question"
    fill_in "survey_question_description", with: "This is a sample Question Description"
    select survey_question_categories(:one).name, from: "survey_question_question_category_id"
    click_on "Add Question"
    assert_selector "p" text: "Question was added successfully."
    take_screenshot
  end

  test "can not create question with empty Name category" do
    visit page_url
    click_on "Add Question"
    take_screenshot
    assert_selector "h1", text: "Add New Question"
  end

  test "can edit a question" do
    visit page_url
    @question = @survey.questions.first
    find("li", id: "#{@question.id}").click_link("Edit")
    fill_in "survey_question_text", with: "question 1"
    click_on "Save"
    assert_selector "p" text: "Question was updated successfully."
  end

  test "can not edit a survey with invalid name" do
    visit page_url
    @question = @survey.questions.first
    find("li", id: "#{@question.id}").click_link("Edit")
    fill_in "survey_question_text", with: ""
    click_on "Save"
    take_screenshot
  end

  test "can delete a question" do
    visit page_url
    @question = @survey.questions.first
    page.accept_confirm do
      find("li", id: "#{@question.id}").click_link("Delete")
    end
    take_screenshot
    assert_selector "p.alert", text: "Question was deleted"
  end
end
