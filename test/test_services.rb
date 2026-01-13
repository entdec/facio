# frozen_string_literal: true

require "test_helper"

class TestServices < Minitest::Test
  include ActiveJob::TestHelper

  def test_can_use_service_with_perform
    subject = SimpleService.perform(value: "test")
    assert subject.performed?
    assert_equal "tset", subject.result
    assert_equal "SimpleService", subject.class.name
  end

  def test_can_use_service_with_perform_now
    subject = SimpleService.perform_now(value: "test")
    assert subject.performed?
    assert_equal "tset", subject.result
    assert_equal "SimpleService", subject.class.name
  end

  def test_can_use_service_with_perform_later
    subject = SimpleService.perform_later
    refute subject.performed?
    assert subject.successfully_enqueued?
  end

  def test_actually_does_something_in_perform_later
    message = Message.create!(text: "test")
    subject = nil
    perform_enqueued_jobs do
      subject = LaterService.perform_later(message: message)
      refute subject.performed?
      assert_equal "LaterService", subject.class.name
      assert subject.successfully_enqueued?
    end
    assert_equal "tset", message.reload.text
  end

  def test_can_use_service_with_inline_context
    subject = InlineService.perform(value: "test")
    assert subject.performed?
    assert_equal "tset", subject.result
    assert_equal "InlineService", subject.class.name
    assert_equal "InlineContext", subject.context.class.name
    assert_equal "Facio::Context", subject.context.class.superclass.name
  end

  def test_can_use_service_with_inline_context_and_result
    subject = InlineResultService.perform(value: "test")
    assert subject.performed?
    assert_equal "tset", subject.result.text
    assert_equal "InlineResultService", subject.class.name
    assert_equal "InlineResultContext", subject.context.class.name
    assert_equal "InlineResultResult", subject.result.class.name
    assert_equal "Facio::Context", subject.context.class.superclass.name
  end

  def test_service_will_not_perform_if_context_is_invalid
    subject = InlineWithValidationsService.perform
    assert_nil subject.result
    refute subject.valid?
    assert subject.invalid?
    refute subject.performed?
    assert_equal "can't be blank", subject.context.errors[:value].first
  end

  # FIXME: How to test it does take the ApplicationContext if defined?
  def test_context_will_use_application_context_if_defined
    skip "This test is not working as expected, the ApplicationContext is not found in the service_context.rb"
    Object.const_set(:ApplicationContext, Class.new(Facio::Context))

    subject = InlineService.perform(value: "test")
    assert subject.performed?
    assert_equal "tset", subject.result
    assert_equal "InlineService", subject.class.name
    assert_equal "InlineContext", subject.context.class.name
    assert_equal "ApplicationContext", subject.context.class.superclass.name
  end

  def test_context_can_fail
    subject = SimpleContext.new
    assert_raises(Facio::ContextFailure, match: /oops/) do
      subject.fail!("oops")
    end
  end

  def test_can_use_service_with_perform_later_with_after_perform
    message = Message.create!(text: "test")
    subject = nil
    perform_enqueued_jobs do
      subject = SimpleWithAfterPerformService.perform_later(message: message)
      refute subject.performed?
      assert_equal "SimpleWithAfterPerformService", subject.class.name
      assert subject.successfully_enqueued?
    end
    assert_equal "tsetafter_perform", message.reload.text
  end

  def test_service_validates_context_before_perform
    subject = SimpleService.perform
    refute subject.performed?
    refute subject.valid?
    assert_equal "can't be blank", subject.context.errors[:value].first
  end
end
