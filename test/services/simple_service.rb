class SimpleService < Mando::Service
  def perform
    context.result = context.value.to_s.reverse
  end
end
