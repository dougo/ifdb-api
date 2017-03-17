require 'test_helper'

class ClubResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test_attributes %i(name keywords desc contacts contacts_plain created members_public)

  test 'web_site link' do
    subject._model.url = 'http://example.com'
    assert_equal 'http://example.com', subject.custom_links[:web_site]
  end

  test 'no web_site link if blank' do
    subject._model.url = ''
    refute_includes subject.custom_links, :web_site
  end

  test 'memberships relationship' do
    assert_kind_of JSONAPI::Relationship::ToMany, ClubResource._relationship(:memberships)
  end
end