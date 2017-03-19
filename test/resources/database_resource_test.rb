require 'test_helper'

class DatabaseResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test 'find_by_key' do
    resource = self.class.described_type.find_by_key(nil, {})
    assert_nil resource
  end
end
