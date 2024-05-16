require_relative "concerns/dsl"

module Mando
  class Service < ActiveJob::Base
    include Dsl

    class << self
      def perform(...)
        puts "perform"
        job = job_or_instantiate(...)
        puts "job"
        job.perform_now
        job.context
      end
    end

    around_perform do |job, block|
      puts "arguments: #{arguments}"
      self.context = self.class.context_class_name.constantize.new(arguments.shift)
      block.call
      context
    end
  end
end
