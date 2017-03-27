require 'test_helper'

class ToQueryTest < ActiveSupport::TestCase
  test 'to_query' do
    assert_equal 'xyzzy', nil.to_query('xyzzy')
  end
end
