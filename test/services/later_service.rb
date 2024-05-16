class LaterService < Mando::Service
  def perform
    context.message.text.reverse!
    context.message.save!
  end
end
