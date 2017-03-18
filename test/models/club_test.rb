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

  test 'members_public is YNBoolean' do
    assert_kind_of YNBoolean, self.class.described_type.attribute_types['members_public']
  end

  should have_many(:news).class_name('NewsItem').with_foreign_key(:sourceid)
    # .as(:newsworthy).with_foreign_type(:source)
  should have_many(:membership).class_name('ClubMembership').with_foreign_key(:clubid)
  # TODO: wishlist and playlist

  test 'contact_tuids' do
    subject.contacts = 'Arthur Dent {arthur_id}, Tricia McMillan {trillian_id}'
    assert_equal %w(arthur_id trillian_id), subject.contact_tuids
  end

  test 'contact_tuids is empty if no TUIDs' do
    subject.contacts = 'Arthur Dent, Tricia McMillan'
    assert_empty subject.contact_tuids
  end

  test 'contact_tuids is empty if contacts is nil' do
    assert_empty subject.contact_tuids
  end

  test 'contact_profiles' do
    arthur, trillian = members(:arthur, :trillian)
    subject.contacts = "Arthur Dent {#{arthur.id}}, Tricia McMillan {#{trillian.id}}"
    assert_equal [arthur, trillian], subject.contact_profiles
  end

  test 'contact_profiles omits nonexistent records' do
    arthur = members(:arthur)
    subject.contacts = "Arthur Dent {#{arthur.id}}, Zaphod Beeblebrox {zaphod_id}"
    assert_equal [arthur], subject.contact_profiles
  end

  test 'relation.includes omits contact_profiles' do
    assert_empty Club.all.includes(:contact_profiles, [:contact_profiles]).includes_values
  end
end
