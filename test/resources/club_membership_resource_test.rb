require 'test_helper'
require 'minitest/mock'

class ClubMembershipResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test 'compound_id' do
    assert_equal %i(clubid userid), ClubMembershipResource._compound_id
  end

  test_attributes %i(joindate admin)

  test 'club relationship' do
    rel = ClubMembershipResource._relationship(:club)
    assert_kind_of JSONAPI::Relationship::ToOne, rel
    assert_equal :clubid, rel.foreign_key
  end

  test 'member relationship' do
    rel = ClubMembershipResource._relationship(:member)
    assert_kind_of JSONAPI::Relationship::ToOne, rel
    assert_equal :userid, rel.foreign_key
  end

  test 'created_field' do
    assert_equal :joindate, ClubMembershipResource.created_field
  end
end
