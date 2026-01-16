module Execution
  extend ActiveSupport::Concern

  # Facio doesn't support arguments in the perform method, that's done with the context object.
  # This is why we override perform here.
  def facio_perform_with_arguments(*args)
    @context = self.class.context_class.new(arguments.first)
    @result = self.class.result_class&.new
    @performed = false
    Rails.logger.error "******************* facio_perform_with_arguments #{@context.valid?}********************"
    Rails.logger.error "******************* facio_perform_with_arguments context #{@context.inspect}********************"
    if @context.valid?
      result = nil
      if transactional && defined?(ActiveRecord::Base)
        ActiveRecord::Base.transaction(requires_new: true) do
          # result = block.call
          Rails.logger.error "*******************Facio transactional********************"
          result = facio_perform_without_arguments
          # This will only rollback the changes of the service, SILENTLY, however the context will be failed? already.
          # This is the most close to expected behaviour this can get.
          raise ActiveRecord::Rollback if context.failed?
        end

      else
        Rails.logger.error "*******************Facio not transactional********************"
        result = facio_perform_without_arguments
      end

      @performed = true
      # Purely as a convenience, but also to enforce a standard
      Rails.logger.error "*******************Facio @result #{@result}********************"
      context.result ||= result if @result.nil?
    end
  end

  included do
    if self < ActiveJob::Base
      def self.method_added(method_name)
        if method_name == :perform
          # Avoid reentrance
          unless method_defined?(:facio_perform_without_arguments)
            # We copy the user defined perform method on the job and set it aside
            alias_method :facio_perform_without_arguments, :perform
            # We take or method above and set that as the new perform method
            # This way we can pass the arguments to the context object
            alias_method :perform, :facio_perform_with_arguments # This invokes method_added(:perform)
          end
        end
      end
    end
  end
end
