module Execution
  extend ActiveSupport::Concern

  # Facio doesn't support arguments in the perform method, that's done with the context object.
  # This is why we override perform here.
  def facio_perform_with_arguments(*args)
    @context = self.class.context_class.new(arguments.first)
    @result = self.class.result_class&.new
    @performed = false

    if @context.valid?
      result = nil
      if transactional && defined?(ActiveRecord::Base)
        ActiveRecord::Base.transaction(requires_new: true) do
          # result = block.call
          result = facio_perform_without_arguments
          # This will only rollback the changes of the service, SILENTLY, however the context will be failed? already.
          # This is the most close to expected behaviour this can get.
          raise ActiveRecord::Rollback if context.failed?
        end

      else
        result = facio_perform_without_arguments
      end

      @performed = true
      # Purely as a convenience, but also to enforce a standard
      context.result ||= result if @result.nil?
    end
  end

  included do
    if self < ActiveJob::Base
      def self.method_added(method_name)
        if method_name == :perform
          # Avoid reentrance
          unless method_defined?(:facio_perform_without_arguments)
            alias_method :facio_perform_without_arguments, :perform
            alias_method :perform, :facio_perform_with_arguments # This invokes method_added(:perform)
          end
        end
      end
    end
  end
end
