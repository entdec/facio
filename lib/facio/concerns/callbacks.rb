module Callbacks
  extend ActiveSupport::Concern

  included do
    around_perform do |job, block|
      @context = self.class.context_class.new(arguments.first)
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

    before_enqueue do |job|
      @performed = false
      @context = self.class.context_class.new(arguments.first)
      @result = self.class.result_class&.new
    end
  end
end
