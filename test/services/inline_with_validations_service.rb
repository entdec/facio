class InlineWithValidationsService < Facio::Service
  context do
    attribute :value
    attribute :result

    validates :value, presence: true
  end
  def perform
    context.result = context.value.to_s.reverse
  end
end
