require 'test_helper'

class UserTest < ActiveSupport::TestCase 
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end
end
