require 'test_helper'

class ClubResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test_attributes %i(name keywords desc contacts contacts_plain created members_public members_count)

  test 'memberships relationship' do
    assert_kind_of JSONAPI::Relationship::ToMany, ClubResource._relationship(:memberships)
  end

  test 'website link' do
    subject._model.url = 'http://example.com'
    assert_equal 'http://example.com', subject.custom_links[:website]
  end

  test 'no website link if blank' do
    subject._model.url = ''
    refute_includes subject.custom_links, :website
  end

  test 'members_count' do
    subject._model.memberships.build([{}, {}])
    assert_equal 2, subject.members_count
  end

  test 'members_count does not load records' do
    model = clubs(:prif)
    subject = ClubResource.new(model, {})
    subject.members_count
    refute_predicate model.memberships, :loaded?
  end

  test 'records includes memberships to avoid N+1 queries from members_count' do
    assert_predicate ClubResource.records({}).first.memberships, :loaded?
  end
end
