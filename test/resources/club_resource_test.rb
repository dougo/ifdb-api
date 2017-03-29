require 'test_helper'

class ClubResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test_attributes %i(name keywords desc contacts contacts_plain listed members_public members_count)

  test 'listed delegates to created' do
    assert_equal :created, ClubResource._attribute_options(:listed)[:delegate]
  end

  test_has_many *%i(membership contact_profiles)

  test 'website link' do
    subject._model.url = 'http://example.com'
    assert_equal 'http://example.com', subject.custom_links[:website]
  end

  test 'no website link if blank' do
    subject._model.url = ''
    refute_includes subject.custom_links, :website
  end

  test 'members_count' do
    subject._model.membership.build([{}, {}])
    assert_equal 2, subject.members_count
  end

  test 'members_count does not load records' do
    model = clubs(:prif)
    subject = ClubResource.new(model, {})
    subject.members_count
    refute_predicate model.membership, :loaded?
  end

  test 'records includes membership to avoid N+1 queries from members_count' do
    assert_predicate ClubResource.records({}).first.membership, :loaded?
  end
end
