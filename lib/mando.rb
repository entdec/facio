# frozen_string_literal: true

require "active_job"
require "active_model"
require "active_support"
require "action_controller"

require_relative "mando/version"
require_relative "mando/active_model/associations"
require_relative "mando/context"
require_relative "mando/service"

module Mando
  class Error < StandardError; end
  # Your code goes here...
end
