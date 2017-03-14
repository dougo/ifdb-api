require 'test_helper'

class ApplicationResourceTest < ActiveSupport::TestCase
  test_extends JSONAPI::Resource

  class TestModel
    def id; :xyzzy end
    def foo; nil end
    def bar; 42 end
    def baz; '' end
    def garply_id; :plugh end
    def quux_id; '' end
  end

  class TestResource < ApplicationResource
    model_name TestModel.name
    attributes :foo, :bar, :baz
    has_one :garply, class_name: 'Test'
    has_one :quux, class_name: 'Test'
  end

  test 'immutable' do
    refute_predicate TestResource, :mutable?
  end

  test 'omits blank attributes and belongs_to relationships with blank foreign key' do
    resource = TestResource.new(TestModel.new, {})
    # Note that there is no #garply or #quux method on TestModel; it should just read the foreign key rather than
    # loading the association.
    assert_same_elements [:id, :bar, :garply], resource.fetchable_fields
  end

  test 'sort by creation time by default' do
    assert_equal [{ field: 'created', direction: :desc }], TestResource.default_sort
  end
end
