require 'test_helper'

class ApplicationResourceTest < ActiveSupport::TestCase
  test_extends JSONAPI::Resource

  test 'abstract' do
    assert_predicate self.class.described_type, :_abstract
  end

  class TestModel
    def id; :xyzzy end
    def foo; nil end
    def bar; 42 end
    def baz; '' end
    def garply_id; :plugh end
    def quux_id; '' end
    def frobs; [] end
  end

  class TestResource < ApplicationResource
    model_name TestModel.name
    attributes :foo, :bar, :baz
    has_one :garply, class_name: 'Test'
    has_one :quux, class_name: 'Test'
    has_many :frobs, class_name: 'Test'
  end

  test 'immutable' do
    refute_predicate TestResource, :mutable?
  end

  test 'omits blank attributes but includes all relationships' do
    resource = TestResource.new(TestModel.new, {})
    assert_same_elements %i(id bar garply quux frobs), resource.fetchable_fields
  end

  test 'sort by creation time by default' do
    assert_equal [{ field: 'created', direction: :desc }], TestResource.default_sort
  end
end
