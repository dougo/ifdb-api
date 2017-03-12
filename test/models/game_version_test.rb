require 'test_helper'

class GameVersionTest < ActiveSupport::TestCase
  test 'is a Version' do
    assert_operator self.class.described_type, :<, Version
  end

  should belong_to(:game).with_foreign_key(:id)
end
