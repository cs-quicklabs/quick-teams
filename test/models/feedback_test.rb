require "test_helper"

class FeedbackTest < ActiveSupport::TestCase
  test "should have user" do
    assert_raises ActiveRecord::NotNullViolation, ActiveRecord::RecordInvalid do
      feedback = Feedback.new(title: "title", body: "note body", critiquable: projects(:one), user: nil)
      feedback.save!
    end
  end

  test "should have critiquable" do
    feedback = Feedback.new
    feedback.valid?
    assert_not feedback.errors[:critiquable].empty?
  end

  test "should have body" do
    feedback = Feedback.new
    feedback.valid?
    assert_not feedback.errors[:body].empty?
  end

  test "should have title" do
    feedback = Feedback.new
    feedback.valid?
    assert_not feedback.errors[:title].empty?
  end
end
