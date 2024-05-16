
module ActiveModel
  module Associations
    extend ActiveSupport::Concern

    class_methods do
      def has_one(association_id, options = {})
        class_name = options[:class_name] || association_id.to_s.classify

        define_method(association_id) do
          instance_variable_get("@#{association_id}") || begin
            instance_variable_set("@#{association_id}", class_name.constantize.new)
          end
        end

        define_method("#{association_id}=") do |new_value|
          instance_variable_set("@#{association_id}", new_value)
        end
      end

      def has_many(association_id, options = {})
        class_name = options[:class_name] || association_id.to_s.singularize.classify
        klass = class_name.constantize

        define_method(association_id) do
          instance_variable_get("@#{association_id}") || begin
            instance_variable_set("@#{association_id}", [])
          end
        end

        # Assignment using models
        define_method("#{association_id}=") do |attributes|
          instance_variable_set("@#{association_id}", attributes)
        end

        # Assignment using attributes, e.g. from a form
        define_method("#{association_id}_attributes=") do |attributes|
          if attributes.is_a?(Hash) || attributes.is_a?(ActionController::Parameters)
            # Reject any attributes that have the are a non-numeric key, e.g. things like "TEMPLATE"
            attributes = attributes.reject { |k, v| k.to_i.to_s != k }.values
            # Reject any attributes that have the _destroy flag set
            attributes = attributes.reject { |v| v["_destroy"] == "1" || v[:_destroy] == "1" }
            attributes = attributes.map { |params| klass.new(params) }

            instance_variable_set("@#{association_id}", attributes)
          end
        end
      end
    end
  end
end
