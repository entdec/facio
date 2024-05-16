module Dsl
  extend ActiveSupport::Concern

  included do
    attr_accessor :context
  end

  class_methods do
    def context_class_name(name = nil)
      @context_class_name = name if name
      @context_class_name || begin
        name = self.name
        name.gsub(/Service\z/, "Context")
      end
    end
  end
end
