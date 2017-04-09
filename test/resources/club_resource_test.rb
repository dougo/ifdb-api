require 'test_helper'

class ClubResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test_attributes %i(name keywords desc contacts contacts_plain listed members_public)

  test 'listed delegates to created' do
    assert_equal :created, ClubResource._attribute_options(:listed)[:delegate]
  end

  test_has_many *%i(membership contact_profiles)

  test 'contact_profiles does not eager load on include' do
    refute ClubResource._relationship(:contact_profiles).eager_load_on_include
  end

  test 'custom_links' do
    subject._model.url = 'http://example.com'
    links = subject.custom_links(serializer: JSONAPI::ResourceSerializer.new(ClubResource))
    assert_equal 'include=contact-profiles', URI(links['self']).query
    assert_equal 'http://example.com', links[:website]
  end

  test 'no website link if blank' do
    subject._model.url = ''
    links = subject.custom_links(serializer: JSONAPI::ResourceSerializer.new(ClubResource))
    refute_includes links, :website
  end

  test 'membership_includes' do
    assert_equal %w(club member), subject.membership_includes
  end

  test 'membership_meta' do
    subject._model.membership.build([{}, {}])
    assert_equal({ count: 2 }, subject.membership_meta({}))
  end

  test 'membership_meta does not load records' do
    model = clubs(:prif)
    subject = ClubResource.new(model, {})
    subject.membership_meta({})
    refute_predicate model.membership, :loaded?
  end

  test 'records includes membership to avoid N+1 queries from membership_meta' do
    assert_predicate ClubResource.records({}).first.membership, :loaded?
  end
end
