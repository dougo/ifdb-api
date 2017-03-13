require 'test_helper'

class NewsItemTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  test 'source attribute' do
    type = self.class.described_type.attribute_types['source']
    assert_instance_of SourceTypeName, type
    assert_equal({ 'C' => 'Competition', 'G' => 'Game', 'U' => 'Club' }, type.name_map)
  end

  should belong_to(:newsworthy).with_foreign_key(:sourceid) # .with_foreign_type(:source)
  should belong_to(:reporter).class_name('Member').with_foreign_key(:userid)
  should belong_to(:superseded_item).class_name('NewsItem').with_foreign_key(:supersedes)
  should have_one(:superseding_item).class_name('NewsItem').with_foreign_key(:supersedes)
  should belong_to(:original_item).class_name('NewsItem').with_foreign_key(:original)
  should have_many(:superseding_items).class_name('NewsItem').with_foreign_key(:original)
  # TODO: have_many(:history) ?
end
