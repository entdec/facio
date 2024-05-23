module Transactional
  extend ActiveSupport::Concern

  included do
    delegate :transactional, to: :class
  end

  class_methods do
    # Allows you to define whether the service should be transactional or not.
    # Setting this to true will run the complete perform method in a transaction.
    #
    # If you do not define this, it will default to false, unless a superclass
    # defines it as true.
    def transactional(value = nil)
      @transactional = value if value
      @transactional = nil unless defined?(@transactional)
      if @transactional.nil?
        @transactional = if superclass < Facio::Service
          superclass.transactional
        else
          false
        end
      end
      @transactional
    end
  end
end
