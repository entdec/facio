require_relative "concerns/service_context"
require_relative "concerns/service_result"
require_relative "concerns/transactional"
require_relative "concerns/translations"
require_relative "concerns/callbacks"
require_relative "concerns/execution"

module Facio
  class Service < ActiveJob::Base
    include ServiceContext
    include ServiceResult
    include Transactional
    include Translations
    include Execution

    class << self
      def perform(...)
        job = job_or_instantiate(...)
        job.perform_now
        job
      end

      def perform_later(...)
        job = job_or_instantiate(...)

        enqueue_result = job.enqueue

        job.instance_variable_set(:@performed, false)
        job.instance_variable_set(:@context, context_class.new(job.arguments.first))
        job.instance_variable_set(:@result, result_class&.new)

        yield job if block_given?

        enqueue_result
      end

      alias_method :perform_now, :perform
    end

    # Returns the result, be it the result object or the context object
    def result
      @result || context.result
    end

    # Returns the errors on the context object
    delegate :errors, to: :@context

    # Returns whether the context is valid
    delegate :valid?, to: :@context
    # Returns whether the coentext is invalid
    delegate :invalid?, to: :@context

    # Returns whether the service has been performed (only when using perform)
    def performed?
      @performed
    end

    # Returns whether the service was successfully performed
    def success?
      success = performed?
      success &&= @result.valid? if @result
      success
    end

    # Returns whether the service failed to perform
    def failed?
      !success?
    end
  end
end
