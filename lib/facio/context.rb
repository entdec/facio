module Facio
  class Context
    include ActiveModel::API
    include ActiveModel::Serializers::JSON
    include ActiveModel::Associations

    def attributes
      instance_values
    end
  end
end
