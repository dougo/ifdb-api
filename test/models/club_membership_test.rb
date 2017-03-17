require 'test_helper'

class ClubMembershipTest < ActiveSupport::TestCase
  test_extends ApplicationRecord

  should have_db_column(:joindate).of_type(:datetime)
  should have_db_column(:admin).of_type(:string).with_options(limit: 1)
  should have_db_index(:clubid)
  should have_db_index(:userid)

  should belong_to(:club).with_foreign_key(:clubid)
  should belong_to(:member).with_foreign_key(:userid)

  test 'admin is YNBoolean' do
    assert_kind_of YNBoolean, self.class.described_type.attribute_types['admin']
  end
end
