require 'test_helper'

class IFIDTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should belong_to(:game).with_foreign_key(:gameid)

  test 'to_s' do
    assert_equal 'foo', IFID.new(ifid: 'foo').to_s
  end
end
