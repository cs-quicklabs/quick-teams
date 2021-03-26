require "test_helper"

class ClientTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
  end

  test "should have account" do
    ActsAsTenant.current_tenant = nil
    assert_raises ActsAsTenant::Errors::NoTenantSet do
      client = Client.new(name: "John")
      client.save
    end
  end

  test "should have name" do
    client = Client.new
    client.valid?
    assert_not client.errors[:name].empty?
  end

  test "should have email" do
    client = Client.new
    client.valid?
    assert_not client.errors[:email].empty?
  end

  test "should have email unique to tenant" do
    client1 = Client.new(name: "Steve", email: "rogers@gmail.com")
    assert client1.save!

    assert_raises ActiveRecord::RecordInvalid do
      client2 = Client.new(name: "Steve", email: "rogers@gmail.com")
      client2.save!
    end

    ActsAsTenant.current_tenant = accounts(:infosys)

    client3 = Client.new(name: "Steve", email: "rogers@gmail.com")
    assert client3.save!

    assert_raises ActiveRecord::RecordInvalid do
      client4 = Client.new(name: "Steve", email: "rogers@gmail.com")
      client4.save!
    end
  end
end
