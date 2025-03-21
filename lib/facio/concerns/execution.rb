module Execution
  extend ActiveSupport::Concern

  def facio_perform_with_arguments(*args)
    facio_perform_without_arguments
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
