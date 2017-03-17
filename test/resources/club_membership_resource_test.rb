require 'test_helper'
require 'minitest/mock'

class ClubMembershipResourceTest < ActiveSupport::TestCase
  include ResourceTesting

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

  test 'primary_key' do
    assert_equal :id, ClubMembershipResource._primary_key
  end

  test 'id' do
    subject._model.assign_attributes(clubid: 'club', userid: 'member')
    assert_equal 'club-member', subject.id
  end

  test 'id filter' do
    filter = ClubMembershipResource._allowed_filters[:id][:apply]
    mock_relation = Minitest::Mock.new
    mock_relation.expect :where, nil, [clubid: 'club', userid: 'member']
    filter.call(mock_relation, 'club-member', {})
    mock_relation.verify
  end
end
