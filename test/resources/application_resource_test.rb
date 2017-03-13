require 'test_helper'

class ApplicationResourceTest < ActiveSupport::TestCase
  test_extends JSONAPI::Resource

  class TestModel
    def id; :xyzzy end
    def foo; nil end
    def bar; 42 end
    def baz; '' end
  end

  class TestResource < ApplicationResource
    model_name TestModel.name
    attributes :foo, :bar, :baz
  end

  test 'immutable' do
    refute_predicate TestResource, :mutable?
  end

  test 'omits blank attributes' do
    resource = TestResource.new(TestModel.new, {})
    assert_equal [:id, :bar], resource.fetchable_fields
  end

  test 'sort by creation time by default' do
    assert_equal [{ field: 'created', direction: :desc }], TestResource.default_sort
  end
end
