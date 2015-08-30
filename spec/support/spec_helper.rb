require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/spec'

begin
  require 'awesome_print'
  module Minitest::Assertions
    def mu_pp(obj)
      obj.awesome_inspect
    end
  end
  require "pry"
rescue LoadError
end

require_relative 'mocks'
