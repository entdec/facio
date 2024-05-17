class SimpleService < Facio::Service
  def perform
    context.result = context.value.to_s.reverse
  end
end
