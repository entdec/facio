class InlineResultService < Facio::Service
  context do
    attribute :value
  end
  result do
    attribute :text
  end
  def perform
    result.text = context.value.to_s.reverse
  end
end
