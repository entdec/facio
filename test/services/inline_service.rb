class InlineService < Facio::Service
  context do
    attribute :value
    attribute :result
  end
  def perform
    context.result = context.value.to_s.reverse
  end
end
