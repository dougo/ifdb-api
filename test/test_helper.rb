ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def assert_valid_json(schema, json, msg=nil)
    # TODO: disallow network connection, keep local copies of referenced schemas
    errors = JSON::Validator.fully_validate(schema, json)
    assert errors.empty?, msg || errors.join("\n")
  end
end
