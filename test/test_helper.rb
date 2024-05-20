# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "facio"

require "active_record"
require "globalid"
require "debug"
require "minitest/autorun"

Dir["test/services/**/*.rb"].sort.each { |file| require File.join(Dir.pwd, file) }
Dir["test/models/**/*.rb"].sort.each { |file| require File.join(Dir.pwd, file) }

ActiveJob::Base.logger = Logger.new(nil)
GlobalID.app = "facio"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: "facio.db"
ActiveRecord::Schema.define do
  self.verbose = false

  create_table :messages, force: true do |t|
    t.string :text
    t.timestamps
  end
end
