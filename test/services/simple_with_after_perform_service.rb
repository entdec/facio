class SimpleWithAfterPerformService < Facio::Service
  context do
    attribute :message
  end
  after_perform do
    context.message.text += "after_perform"
    context.message.save!
  end
  def perform
    context.message.text.reverse!
    context.message.save!
  end
end
