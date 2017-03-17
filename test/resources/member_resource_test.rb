require 'test_helper'

class MemberResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  test_attributes %i(name gender location publicemail profile created)

  test 'games relationship' do
    assert_kind_of JSONAPI::Relationship::ToMany, MemberResource._relationship(:games)
  end
  
  test 'picture link' do
    subject._model.picture = 'http://example.com/pic.jpg'
    assert_equal 'http://example.com/pic.jpg', subject.custom_links({})[:picture]
  end

  test 'no picture link if blank' do
    subject._model.picture = ''
    refute_includes subject.custom_links({}), :picture
  end

  test 'conforms to schema' do
    schema = MemberSchema.new
    assert_valid_json schema, serialize(members(:minimal))
    assert_valid_json schema, serialize(members(:maximal))
  end

  private
  
  def serialize(model)
    JSONAPI::ResourceSerializer.new(MemberResource).serialize_to_hash(MemberResource.new(model, {}))[:data]
  end
end
