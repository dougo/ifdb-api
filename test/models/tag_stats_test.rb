require 'test_helper'

class TagStatsTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should have_many(:game_tags).with_foreign_key(:tag)
  should have_many(:games).through(:game_tags)

  # TODO: add have_primary_key to shoulda-matchers?
  test 'primary_key' do
    assert_equal 'tag', self.class.described_type.primary_key
  end
end
