ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Don't try to get schemas from the network when validating.
JSON::Validator.schema_reader = JSON::Schema::Reader.new(accept_uri: false)

def add_vendor_schema(name, uri)
  path = File.expand_path("../../vendor/schemas/#{name}.json", __FILE__)
  schema = JSON::Schema.new(JSON::Validator.parse(File.read(path)), Addressable::URI.parse(uri))
  JSON::Validator.add_schema(schema)
end

add_vendor_schema('core-base', 'http://hyperschema.org/core/base#')
add_vendor_schema('core-link', 'http://hyperschema.org/core/link#')
add_vendor_schema('hal', 'http://hyperschema.org/mediatypes/hal#')

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def assert_valid_json(schema, json, msg=nil)
    errors = JSON::Validator.fully_validate(schema.as_json, json)
    assert errors.empty?, msg || errors.join("\n")
  end
end
