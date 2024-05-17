module Facio
  class BaseModel
    include ActiveModel::API
    include ActiveModel::Serializers::JSON
    include ActiveModel::Associations
    include ActiveModel::Attributes
  end
end
