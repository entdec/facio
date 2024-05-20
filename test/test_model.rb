# frozen_string_literal: true

require "test_helper"

class TestModel < Minitest::Test
  def test_type_with_model
    message = Message.create!(text: "test")
    some_model = ModelCast.new(message: message)
    assert_equal message, some_model.message
  end

  def test_type_with_id
    message = Message.create!(text: "test")
    some_model = ModelCast.new(message: message.id.to_s)
    assert_equal message, some_model.message
  end
end
