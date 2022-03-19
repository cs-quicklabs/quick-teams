require "test_helper"

class TicketStatusTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
  end

  test "should have account" do
    ActsAsTenant.current_tenant = nil
    assert_raises ActsAsTenant::Errors::NoTenantSet do
      ticket_status = TicketStatus.new(name: "ticket_status")
      ticket_status.save
    end
  end

  test "should have name" do
    ticket_status = TicketStatus.new
    ticket_status.valid?
    assert_not ticket_status.errors[:name].empty?
  end

  test "should have name unique to tenant" do
    ticket_status = TicketStatus.new(name: "ticket_status")
    assert ticket_status.save!

    assert_raises ActiveRecord::RecordInvalid do
      ticket_status2 = TicketStatus.new(name: "ticket_status")
      ticket_status2.save!
    end

    ActsAsTenant.current_tenant = accounts(:infosys)

    ticket_status3 = TicketStatus.new(name: "ticket_status")
    assert ticket_status3.save!

    assert_raises ActiveRecord::RecordInvalid do
      ticket_status4 = TicketStatus.new(name: "ticket_status")
      ticket_status4.save!
    end
  end
end
