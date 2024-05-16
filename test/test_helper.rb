# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "mando"

require "active_record"
require "globalid"
require "debug"
require "minitest/autorun"

require "models/address"
require "models/contact"
require "models/message"

require "services/simple_service"
require "services/simple_context"

require "services/later_service"
require "services/later_context"

# ActiveJob::Base.logger = Logger.new(nil)

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: "mando.db"
ActiveRecord::Schema.define do
  self.verbose = false

  create_table :messages, force: true do |t|
    t.string :text
    t.timestamps
  end
end
