require 'test_helper'

class ReviewResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test_attributes %i(summary review rating createdate moddate embargodate)

  test 'reviewer relationship' do
    rel = ReviewResource._relationship(:reviewer)
    assert_kind_of JSONAPI::Relationship::ToOne, rel
    assert_equal :userid, rel.foreign_key
  end

  test 'created_field' do
    assert_equal :moddate, ReviewResource.created_field
  end
end
