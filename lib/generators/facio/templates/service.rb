# frozen_string_literal: true

class <%= name.camelize %>Service < ApplicationService
  before_perform do
  end

  after_perform do
  end

  def perform
    context.some.reverse!
  end
end
