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
    include Callbacks
    include Execution

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
