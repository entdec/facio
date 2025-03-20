require_relative "concerns/service_context"
require_relative "concerns/service_result"
require_relative "concerns/transactional"
require_relative "concerns/translations"

module Facio
  class Service < ActiveJob::Base
    include ServiceContext
    include ServiceResult
    include Transactional
    include Translations

    around_perform do |job, block|
      @context = self.class.context_class.new(arguments.shift)
      @result = self.class.result_class&.new
      @performed = false

      if @context.valid?
        result = nil
        if transactional && defined?(ActiveRecord::Base)
          ActiveRecord::Base.transaction(requires_new: true) do
            result = block.call
            # This will only rollback the changes of the service, SILENTLY, however the context will be failed? already.
            # This is the most close to expected behaviour this can get.
            raise ActiveRecord::Rollback if context.failed?
          end

        else
          result = block.call
        end

        @performed = true
        # Purely as a convenience, but also to enforce a standard
        context.result ||= result if @result.nil?
      end
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
    delegate :errors, to: :@context

    # Returns whether the context is valid
    delegate :valid?, to: :@context
    delegate :invalid?, to: :@context

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
