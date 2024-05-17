# frozen_string_literal: true

require "active_job"
require "active_model"
require "active_support"
require "action_controller"

require_relative "facio/version"
require_relative "facio/active_model/associations"
require_relative "facio/context"
require_relative "facio/service"

module Facio
  class Error < StandardError; end
  # Your code goes here...
end
