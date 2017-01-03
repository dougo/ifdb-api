require 'test_helper'

class UserResourceTest < ActiveSupport::TestCase
  test 'UserResource' do
    assert_equal JSONAPI::Resource, UserResource.superclass
    refute_predicate UserResource, :mutable?
  end

  test 'attributes' do
    %i(name gender location publicemail profile picture created).each do |attr|
      assert_includes UserResource._attributes, attr
    end
  end

  test 'conforms to schema' do
    schema = UserResourceSchema.new.as_json
    ser = JSONAPI::ResourceSerializer.new(UserResource)
    json = ser.serialize_to_hash(UserResource.new(users(:molydeux), {}))
    assert_valid_json schema, json
  end
end
