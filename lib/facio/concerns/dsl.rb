module Dsl
  extend ActiveSupport::Concern

  included do
    attr_accessor :context
  end

  class_methods do
    # Allows you to define the context of the service inline:
    #
    # context do
    #   attr_accessor :value
    # end
    #
    # Under normal circumstances the context class is subclassed from Facio::Context, but if you want to override
    # this behaviour you can pass a base_class as an argument.
    #
    def context(base_class: Facio::Context, &)
      @context_class = Object.const_set(derived_context_name, Class.new(base_class))
      @context_class.instance_exec(&)
    end

    # Allows you to define the context class name for this service, when it's different than the default.
    def context_class_name(name = nil)
      @context_class_name = name if name
      @context_class_name || derived_context_name
    end

    # Helpers

    def context_class
      @context_class || context_class_name.safe_constantize
    end

    def derived_context_name
      name = self.name
      name.gsub(/Service\z/, "Context")
    end
  end
end
