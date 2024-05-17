require_relative "concerns/dsl"

module Facio
  class Service < ActiveJob::Base
    include Dsl

    around_perform do |job, block|
      if self.class.context_class
        self.context = self.class.context_class.new(arguments.shift)
      end

      result = block.call

      context.result ||= result
      context
    end

    class << self
      def perform(...)
        job = job_or_instantiate(...)
        job.perform_now
        job.context
      end
    end
  end
end
