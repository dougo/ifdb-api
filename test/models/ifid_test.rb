require 'test_helper'

class IFIDTest < ActiveSupport::TestCase
  test 'is an ApplicationRecord' do
    assert_kind_of ApplicationRecord, subject
  end

  should belong_to(:game).with_foreign_key(:gameid)

  test 'to_s' do
    assert_equal 'foo', IFID.new(ifid: 'foo').to_s
  end
end
