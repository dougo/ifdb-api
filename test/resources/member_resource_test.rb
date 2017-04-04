require 'test_helper'

class MemberResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  # TODO: don't include both profile and profile_summary
  test_attributes %i(name gender location publicemail profile profile_summary since)

  test 'since delegates to created' do
    assert_equal :created, MemberResource._attribute_options(:since)[:delegate]
  end

  test_has_many *%i(games played_games wishlist not_interested)
  
  test 'picture and thumbnail links' do
    subject._model.picture = 'http://example.com/showuser?pic'
    links = subject.custom_links({})
    assert_equal 'http://example.com/showuser?ldesc&pic', links[:picture]
    assert_equal 'http://example.com/showuser?pic&thumbnail=80x80', links[:thumbnail]
    assert_equal 'http://example.com/showuser?pic&thumbnail=250x250', links[:large_thumbnail]
  end

  test 'no picture or thumbnail links if blank' do
    subject._model.picture = ''
    links = subject.custom_links({})
    refute_includes links, :picture
    refute_includes links, :thumbnail
    refute_includes links, :large_thumbnail
  end

  test 'links when picture has no query' do
    subject._model.picture = 'http://example.com'
    links = subject.custom_links({})
    assert_equal 'http://example.com?ldesc', links[:picture]
    assert_equal 'http://example.com?thumbnail=80x80', links[:thumbnail]
    assert_equal 'http://example.com?thumbnail=250x250', links[:large_thumbnail]
  end

  test 'profile_summary' do
    subject._model.profile = 'A' * 150
    assert_equal 'A' * 100 + '...', subject.profile_summary
  end

  test 'conforms to schema' do
    schema = MemberSchema.new
    assert_valid_json schema, serialize(members(:minimal))
    assert_valid_json schema, serialize(members(:maximal))
  end
end
