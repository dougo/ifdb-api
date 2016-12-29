require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'User is an ApplicationRecord' do
    assert_equal ApplicationRecord, User.superclass
  end
end
