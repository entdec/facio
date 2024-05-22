require_relative "concerns/service_context"
require_relative "concerns/service_result"
require_relative "concerns/translations"

module Facio
  class Service < ActiveJob::Base
    include ServiceContext
    include ServiceResult

    around_perform do |job, block|
      @context = self.class.context_class.new(arguments.shift)
      @result = self.class.result_class&.new
      @performed = false

      if @context.valid?
        result = block.call
        @performed = true
        # Purely as a convenience, but also to enforce a standard
        context.result ||= result if @result.nil?
      end

      self
    end

    around_enqueue do |job, block|
      @performed = false
      @context = self.class.context_class.new(arguments.first)
      @result = self.class.result_class&.new
      block.call
    end

    class << self
      def perform(...)
        job = job_or_instantiate(...)
        job.perform_now
        job
      end

      alias_method :perform_now, :perform
    end

    # Returns the result, be it the result object or the context object
    def result
      @result || context.result
    end

    # Returns the errors on the context object
    def errors
      @context.errors
    end

    # Returns whether the context is valid
    def valid?
      @context.valid?
    end

    def performed?
      @performed
    end

    def success?
      success = performed? && valid?
      success &&= @result.valid? if @result
      success
    end

    def failed?
      !success?
    end
  end
end
