require "test_helper"

class NoteTest < ActiveSupport::TestCase
  test "should have body" do
    note = Note.new
    note.valid?
    assert_not note.errors[:body].empty?
  end

  test "should have notable" do
    note = Note.new
    note.valid?
    assert_not note.errors[:notable].empty?
  end

  test "should have user" do
    assert_raises ActiveRecord::NotNullViolation, ActiveRecord::RecordInvalid do
      note = Note.new(body: "note body", notable: projects(:one))
      note.save!
    end
  end
end
