require 'test_helper'

class CompetitionVersionTest < ActiveSupport::TestCase
  test 'is a Version' do
    assert_operator self.class.described_type, :<, Version
  end

  should belong_to(:competition).with_foreign_key(:compid)
end
