# frozen_string_literal: true

class Message < ActiveRecord::Base
  include GlobalID::Identification
end
