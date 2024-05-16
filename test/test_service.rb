# frozen_string_literal: true

require "test_helper"

class TestService < Minitest::Test
  def test_can_use_service_with_perform
    assert_equal "tset", SimpleService.perform(value: "test").result
  end

  def test_can_use_service_with_perform_later
    result = SimpleService.perform_later
    assert true, result.successfully_enqueued?
  end
end
