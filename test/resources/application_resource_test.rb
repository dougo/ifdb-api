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
    def frobs; [1, 2, 3] end
  end

  class TestResource < ApplicationResource
    model_name TestModel.name
    attributes :foo, :bar, :baz
    has_one :garply, class_name: 'Test'
    has_one :quux, class_name: 'Test'
    has_many :frobs, class_name: 'Test'

    def self.created_field
      :born_on
    end
  end

  test 'immutable' do
    refute_predicate TestResource, :mutable?
  end

  test 'omits blank attributes but includes all relationships' do
    resource = TestResource.new(TestModel.new, {})
    assert_same_elements %i(id bar garply quux frobs), resource.fetchable_fields
  end

  test 'created_field' do
    assert_equal :created, ApplicationResource.created_field
  end

  test 'sort by creation time by default' do
    assert_equal [{ field: :born_on, direction: :desc }], TestResource.default_sort
  end

  class ApplicationResource::SerializerTest < ActiveSupport::TestCase
    test_extends JSONAPI::ResourceSerializer

    subject { self.class.described_type.new(TestResource) }

    test 'link_builder' do
      assert_kind_of ApplicationResource::LinkBuilder, subject.link_builder
    end
  end

  class ApplicationResource::LinkBuilderTest < ActiveSupport::TestCase
    test_extends JSONAPI::LinkBuilder

    subject do
      self.class.described_type.new(base_url: 'http://www.example.com',
                                    route_formatter: JSONAPI.configuration.route_formatter,
                                    primary_resource_klass: TestResource)
    end

    test 'relationships_related_link includes meta if relationship has meta' do
      resource = TestResource.new(TestModel.new, {})
      relationship = JSONAPI::Relationship::ToMany.new(:frobs, meta: proc { { count: frobs.size } })
      expected = {
        href: 'http://www.example.com/application-resource-test/tests/xyzzy/frobs',
        meta: { count: 3 }
      }
      assert_equal expected, subject.relationships_related_link(resource, relationship, {})
    end

    test 'relationships_related_link is string if relationship has no meta' do
      resource = TestResource.new(TestModel.new, {})
      relationship = JSONAPI::Relationship::ToMany.new(:frobs)
      expected = 'http://www.example.com/application-resource-test/tests/xyzzy/frobs'
      assert_equal expected, subject.relationships_related_link(resource, relationship)
    end
  end
end
