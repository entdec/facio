# frozen_string_literal: true

require "test_helper"

class TestAssociations < Minitest::Test
  def test_can_use_assocations_with_active_model
    c = Contact.new(name: "David", email: "david@example.com", message: "Hello World")
    c.addresses = [Address.new(city: "Washington")]
    assert_equal "Address", c.addresses.first.class.name
    assert_equal "Washington", c.addresses.first.city
  end

  def test_can_use_assocations_with_hash
    c = Contact.new(name: "David", email: "david@example.com", message: "Hello World")
    c.addresses_attributes = {"0" => {city: "Washington"}}
    assert_equal "Address", c.addresses.first.class.name
    assert_equal "Washington", c.addresses.first.city
  end

  def test_can_use_assocations_with_hash_filters_out_template_keys
    c = Contact.new(name: "David", email: "david@example.com", message: "Hello World")
    c.addresses_attributes = {"0" => {city: "Washington"}, "TEMPLATE" => {city: ""}}
    assert 1, c.addresses.size
  end

  def test_can_use_assocations_with_hash_filters_out_to_be_destroyed_keys
    c = Contact.new(name: "David", email: "david@example.com", message: "Hello World")
    c.addresses_attributes = {"0" => {city: "Washington"}, "1" => {:city => "Phoenix", "_destroy" => "1"}}
    assert 1, c.addresses.size
  end
end
