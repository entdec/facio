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
  end

  def test_can_use_service_with_inline_context
    subject = InlineService.perform(value: "test")
    assert_equal "tset", subject.result
    assert_equal "InlineContext", subject.class.name
    assert_equal "Facio::Context", subject.class.superclass.name
  end

  def test_context_will_use_application_context_if_defined
    skip "Doesn't work yet, can't seem to define ApplicationContext and find it in dsl.rb/context_base_class"
    Object.const_set("ApplicationContext", Class.new(Facio::Context))

    subject = InlineService.perform(value: "test")
    assert_equal "tset", subject.result
    assert_equal "InlineContext", subject.class.name
    assert_equal "ApplicationContext", subject.class.superclass.name
  end
end
