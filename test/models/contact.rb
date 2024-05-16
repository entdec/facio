class Contact
  include ActiveModel::API
  include ActiveModel::Serializers::JSON
  include ActiveModel::Associations

  attr_accessor :name, :email, :message
  validates :name, :email, :message, presence: true
  # attr_accessor :addresses

  has_many :addresses, class_name: "Address"
  # accepts_nested_attributes_for :addresses

  def attributes
    instance_values
  end
end
