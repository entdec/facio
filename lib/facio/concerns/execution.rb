module Execution
  extend ActiveSupport::Concern

  # Facio doesn't support arguments in the perform method, that's done with the context object.
  # This is why we override perform here.
  def facio_perform_with_arguments(*args)
    facio_perform_without_arguments
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
