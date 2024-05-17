class Address < Facio::BaseModel
  attribute :street
  attribute :city
  attribute :state
  attribute :zip
  validates :street, :city, :state, :zip, presence: true
end
