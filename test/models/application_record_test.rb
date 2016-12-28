require 'test_helper'

class ApplicationRecordTest < ActiveSupport::TestCase
  test 'includes Serializable' do
    assert_includes ApplicationRecord, Serializable
  end
end
