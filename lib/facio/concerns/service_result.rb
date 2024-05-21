module ServiceResult
  extend ActiveSupport::Concern

  class_methods do
    # Allows you to define the result of the service inline:
    #
    # result do
    #   attr_accessor :value
    # end
    #
    # Under normal circumstances the result class is subclassed from Facio::Result, but if you want to override
    # this behaviour you can pass a base_class as an argument.
    #
    def result(base_class: result_base_class, &)
      @result_class = Object.const_set(derived_result_name, Class.new(base_class))
      @result_class.instance_exec(&)
    end

    # Allows you to define the result class name for this service, when it's different than the default.
    def result_class_name(name = nil)
      @result_class_name = name if name
      @result_class_name || derived_result_name
    end

    # Helpers

    def result_base_class
      # FIXME: This doesn't work sadly
      Object.const_defined?("ApplicationResult") ? Object.const_get("ApplicationResult") : Facio::Result
    end

    def result_class
      @result_class || result_class_name.safe_constantize
    end

    def derived_result_name
      name = self.name
      name.gsub(/Service\z/, "Result")
    end
  end
end
