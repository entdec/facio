# frozen_string_literal: true

require "test_helper"

class TestServices < Minitest::Test
  include ActiveJob::TestHelper

  def test_can_use_service_with_perform
    assert_equal "tset", SimpleService.perform(value: "test").result
  end

  def test_can_use_service_with_perform_later
    result = SimpleService.perform_later
    assert true, result.successfully_enqueued?
  end

  def test_actually_does_something_in_perform_later
    message = Message.create!(text: "test")
    perform_enqueued_jobs do
      result = LaterService.perform_later(message: message)
      assert true, result.successfully_enqueued?
    end
    assert_equal "tset", message.reload.text
    binding.pry
  end
end
