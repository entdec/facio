class LaterService < Facio::Service
  def perform
    context.message.text.reverse!
    context.message.save!
  end
end
