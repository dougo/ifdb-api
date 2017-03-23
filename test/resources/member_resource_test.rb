require 'test_helper'

class MemberResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  # TODO: don't include both profile and profile_summary
  test_attributes %i(name gender location publicemail profile profile_summary since)

  test 'since delegates to created' do
    assert_equal :created, MemberResource._attribute_options(:since)[:delegate]
  end

  test 'games relationship' do
    assert_kind_of JSONAPI::Relationship::ToMany, MemberResource._relationship(:games)
  end
  
  test 'picture and thumbnail links' do
    subject._model.picture = 'http://example.com/showuser?pic'
    assert_equal 'http://example.com/showuser?pic', subject.custom_links({})[:picture]
    assert_equal 'http://example.com/showuser?pic&thumbnail=80x80', subject.custom_links({})[:thumbnail]
  end

  test 'no picture or thumbnail link if blank' do
    subject._model.picture = ''
    refute_includes subject.custom_links({}), :picture
    refute_includes subject.custom_links({}), :thumbnail
  end

  test 'thumbnail when picture has no query' do
    subject._model.picture = 'http://example.com'
    assert_equal 'http://example.com?thumbnail=80x80', subject.custom_links({})[:thumbnail]
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
