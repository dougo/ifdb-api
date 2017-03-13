require 'test_helper'

class ApplicationRecordTest < ActiveSupport::TestCase
  test_extends ActiveRecord::Base

  test 'includes Serializable' do
    assert_includes ApplicationRecord, Serializable
  end
end
