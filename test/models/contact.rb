class Contact < Facio::BaseModel
  attribute :name
  attribute :email
  attribute :message
  validates :name, :email, :message, presence: true

  has_many :addresses, class_name: "Address"

  def attributes
    instance_values
  end
end
