# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "mando"

require "debug"
require "minitest/autorun"

require "models/address"
require "models/contact"

require "services/simple_service"
require "services/simple_context"

ActiveJob::Base.logger = Logger.new(nil)
