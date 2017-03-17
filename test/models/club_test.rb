require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should have_db_column(:name).of_type(:string)
  should have_db_column(:keywords).of_type(:text)
  should have_db_column(:desc).of_type(:text)
  should have_db_column(:url).of_type(:text)
  should have_db_column(:contacts).of_type(:text)
  should have_db_column(:contacts_plain).of_type(:text)
  should have_db_column(:created).of_type(:datetime)
  should have_db_column(:members_public).of_type(:string).with_options(limit: 1)
  should have_db_index(%i(name keywords desc))

  should have_many(:news).class_name('NewsItem').with_foreign_key(:sourceid)
    # .as(:newsworthy).with_foreign_type(:source)
  should have_many(:membership).class_name('ClubMembership').with_foreign_key(:clubid)
  # TODO: wishlist and playlist

  test 'members_public is YNBoolean' do
    assert_kind_of YNBoolean, self.class.described_type.attribute_types['members_public']
  end
end
