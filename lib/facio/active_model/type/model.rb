module ActiveModel
  module Type
    class Model < ActiveModel::Type::Value
      attr_reader :class_name
      def initialize(**options)
        @class_name = options.delete(:class_name)
        super()
      end

      def cast(value)
        return nil if value.nil?

        klass = class_name.constantize
        if value.is_a?(::Integer) || value.is_a?(::String)
          klass.find(value)
        elsif value.is_a?(klass)
          value
        end
      end
    end
  end
end

ActiveModel::Type.register(:model, ActiveModel::Type::Model)
