module Facio
  class Context < BaseModel
    attribute :result

    def fail!(attr = nil, message = :invalid, options = {})
      @success = false
      merge_errors!(attr, message, options)
      raise Facio::ContextFailure, self
    end

    def failed?
      errors.any?
    end

    def success?
      errors.none?
    end

    private

    def merge_errors!(attr, message = :invalid, options = {})
      return unless attr

      if attr.is_a? String
        errors.add(:base, attr)
      elsif attr.is_a? ActiveModel::Errors
        errors.merge!(attr)
      elsif attr.is_a? Symbol
        errors.add(attr, message, **options)
      end
    end
  end
end
