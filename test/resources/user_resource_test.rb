require 'test_helper'

class UserResourceTest < ActiveSupport::TestCase
  test 'is an immutable ApplicationResource' do
    assert_equal ApplicationResource, UserResource.superclass
    refute_predicate UserResource, :mutable?
  end

  test 'attributes' do
    %i(name gender location publicemail profile picture created).each do |attr|
      assert_includes UserResource._attributes, attr
    end
  end

  test 'conforms to schema' do
    schema = UserResourceSchema.new.as_json
    assert_valid_json schema, serialize(users(:minimal))
    assert_valid_json schema, serialize(users(:maximal))
  end

  private

  def resource(model)
    UserResource.new(model, {})
  end
  
  def serialize(model)
    JSONAPI::ResourceSerializer.new(UserResource).serialize_to_hash(resource(model))
  end
end
