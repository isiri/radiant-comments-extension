require 'test/unit'
# Load the environment
unless defined? RADIANT_ROOT
  ENV["RAILS_ENV"] = "test"
  require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/config/environment"
end
require "#{RADIANT_ROOT}/test/test_helper"
require 'mocha'

class Test::Unit::TestCase
  test_helper :extension_fixtures, :extension_tags
  
  self.fixture_path << File.dirname(__FILE__) + "/fixtures"
end