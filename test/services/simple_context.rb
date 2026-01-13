class SimpleContext < Facio::Context
  attribute :value
  attribute :result

  validates :value, presence: true
end
